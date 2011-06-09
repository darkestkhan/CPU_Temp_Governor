pragma License (GPL);
------------------------------------------------------------------------------
-- Author: darkestkhan                                                      --
-- Email: darkestkhan@gmail.com                                             --
-- License: GNU GPLv3 or any later as published by Free Software Foundation --
-- (see README file)                                                        --
--                    Copyright © 2010 darkestkhan                          --
------------------------------------------------------------------------------
--  This Program is Free Software: You can redistribute it and/or modify    --
--  it under the terms of The GNU General Public License as published by    --
--    the Free Software Foundation, either version 3 of the license, or     --
--                (at Your option) any later version.                       --
--                                                                          --
--      This Program is distributed in the hope that it will be useful,     --
--      but WITHOUT ANY WARRANTY; without even the implied warranty of      --
--      MERCHANTABILITY or FITNESS for A PARTICULAR PURPOSE. See the        --
--              GNU General Public License for more details.                --
--                                                                          --
--    You should have received a copy of the GNU General Public License     --
--   along with this program. If not, see <http://www.gnu.org/licenses/>.   --
------------------------------------------------------------------------------
with Ada.Text_IO;
package body Gov.Frequency is

  function Freq_Step_Image (This: in Freq_Step) return String is
  begin
    case This is
      when First => return "1000000";
      when Second => return "1333000";
      when Third => return "1667000";
      when Fourth => return "2167000";
    end case;
  end Freq_Step_Image;

  function Freq_Step_Value (This: in String) return Freq_Step is
  begin
    if This = "1000000" then
      return First;
    elsif This = "1333000" then
      return Second;
    elsif This = "1667000" then
      return Third;
    elsif This = "2167000" then
      return Fourth;
    else
      raise Core_Meltdown with This;
    end if;
  exception
    when Core_Meltdown => Ada.Text_IO.Put_Line ("Frequency of " & This & " caused core meltdown.");
                          raise Program_Error;
  end Freq_Step_Value;

  function Create_Pathname (From: in String) return Pathname is
    var: Pathname;
  begin
    var := new String (From'First .. From'Last);
    for I in From'Range loop
      var (I) := From (I);
    end loop;
    return var;
  end Create_Pathname;

  procedure Dec_Freq (This: in out CPU_Freq) is
    File: Ada.Text_IO.File_Type;
  begin
    if Freq_Step'Pos (This.Max) - Freq_Step'Pos (This.Min) > 0 then
      This.Max := Freq_Step'Val (Freq_Step'Pos (This.Max) - 1);
      Ada.Text_IO.Open (File => File, Name => (This.Path.all & "scaling_max_freq"), Mode => Ada.Text_IO.Out_File);
      Ada.Text_IO.Put_Line (File => File, Item => Freq_Step_Image (This.Max));
      Ada.Text_IO.Close (File => File);
    else
      return;
    end if;
  end Dec_Freq;

  procedure Inc_Freq (This: in out CPU_Freq) is
    File: Ada.Text_IO.File_Type;
  begin
    if This.Max /= Freq_Step'Last then
      This.Max := Freq_Step'Val (Freq_Step'Pos (This.Max) + 1);
      Ada.Text_IO.Open (File => File, Name => (This.Path.all & "scaling_max_freq"), Mode => Ada.Text_IO.Out_File);
      Ada.Text_IO.Put_Line (File => File, Item => Freq_Step_Image (This.Max));
      Ada.Text_IO.Close (File => File);
    else
      return;
    end if;
  end Inc_Freq;

  function Get_Min_Freq (This: in CPU_Freq) return Freq_Step is
    File: Ada.Text_IO.File_Type;
    Result: Freq_Step;
  begin
    Ada.Text_IO.Open (File => File, Name => (This.Path.all & "scaling_min_freq"), Mode => Ada.Text_IO.In_File);
    Result := Freq_Step_Value (Ada.Text_IO.Get_Line (File => File));
    Ada.Text_IO.Close (File => File);
    return Result;
  end Get_Min_Freq;

  function Get_Max_Freq (This: in CPU_Freq) return Freq_Step is
    File: Ada.Text_IO.File_Type;
    Result: Freq_Step;
  begin
    Ada.Text_IO.Open (File => File, Name => (This.Path.all & "scaling_max_freq"), Mode => Ada.Text_IO.In_File);
    Result := Freq_Step_Value (Ada.Text_IO.Get_Line (File => File));
    Ada.Text_IO.Close (File => File);
    return Result;
  end Get_Max_Freq;

  procedure Init_CPU_Freq (This: in out CPU_Freq; Path: in String) is
  begin
    This.Path := Create_Pathname (From => Path);
    This.Min := Get_Min_Freq (This => This);
    This.Max := Get_Max_Freq (This => This);
  end Init_CPU_Freq;

  procedure Print_CPU_Freq (This: in CPU_Freq) is
  begin
    Ada.Text_IO.Put_Line ("Path is: " & This.Path.all);
    Ada.Text_IO.Put_Line ("Minimum frequency is: " & Freq_Step_Image (This.Min));
    Ada.Text_IO.Put_Line ("Maximum frequency is: " & Freq_Step_Image (This.Max));
  end Print_CPU_Freq;

  procedure Actualize_Freq (This: in out CPU_Freq) is
  begin
    This.Min := Get_Min_Freq (This => This);
    This.Max := Get_Max_Freq (This => This);
  end Actualize_Freq;

end Gov.Frequency;
