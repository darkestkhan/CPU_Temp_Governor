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
with Gov.Temperature;
with Gov.Frequency;
use type Gov.Temperature.Temperature;
with Gov.Temperature_IO;
with Ada.Strings.Unbounded;
use type Ada.Strings.Unbounded.Unbounded_String;
with Ada.Command_Line;
procedure Start_Gov is

  type CPU_Array is array (Natural range <>) of Gov.Frequency.CPU_Freq;
  type CPU_Address is array (Natural range <>) of Ada.Strings.Unbounded.Unbounded_String;

  Hi_Temp: constant Gov.Temperature.Temperature := 90.000;
  Lo_Temp: constant Gov.Temperature.Temperature := 85.000;

  task Governor is
    entry Start;
  end Governor;

  task body Governor is
    CPUs: CPU_Array (0 .. 1);
    CPUs_Addresses: CPU_Address (CPUs'Range);
    Temp: Gov.Temperature.Temperature;
  begin
    accept Start;
      CPUs_Addresses (0) := Ada.Strings.Unbounded.To_Unbounded_String ("cpu0");
      CPUs_Addresses (1) := Ada.Strings.Unbounded.To_Unbounded_String ("cpu1");
      for I in CPUs'Range loop
        Gov.Frequency.Init_CPU_Freq (This => CPUs (I), Path => Ada.Strings.Unbounded.To_String (CPUs_Addresses (I)));
      end loop;
      loop
        Temp := Gov.Temperature.Read_Temp;
        if Temp > Hi_Temp then
          for I in CPUs'Range loop
            Gov.Frequency.Actualize_Freq (CPUs (I));
            Gov.Frequency.Dec_Freq (CPUs (I));
          end loop;
        elsif Temp < Lo_Temp then
          for I in CPUs'Range loop
            Gov.Frequency.Actualize_Freq (CPUs (I));
            Gov.Frequency.Inc_Freq (CPUs (I));
          end loop;
        end if;
        delay 3.0;
      end loop;
  end Governor;

  procedure Parse_Argv is

    procedure Version is
    begin
      Ada.Text_IO.Put_Line (Ada.Command_Line.Command_Name & " v 0.0.1");
    end Version;

    procedure Usage is
    begin
      null; -- TODO
    end Usage;

    procedure Help is
    begin
      Ada.Text_IO.Put_Line ("CPU frequency caling governor, depending on the temperature of CPU.");
      Usage;
      Version;
      Ada.Text_IO.Put_Line ("License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>");
      Ada.Text_IO.Put_Line ("copyright (c) darkestkhan 2011");
    end Help;

    procedure Verbose is
    begin
      null; -- TODO
    end Verbose;

    Arg: Ada.Strings.Unbounded.Unbounded_String;

  begin
    if Ada.Command_Line.Argument_Count > 0 then
      for I in 1 .. Ada.Command_Line.Argument_Count loop
        Arg := Ada.Strings.Unbounded.To_Unbounded_String (Ada.Command_Line.Argument (I));
        if Arg = Ada.Strings.Unbounded.To_Unbounded_String ("-h") or else Arg = Ada.Strings.Unbounded.To_Unbounded_String ("--help") then
          Help;
        elsif Arg = Ada.Strings.Unbounded.To_Unbounded_String ("-v") or else Arg = Ada.Strings.Unbounded.To_Unbounded_String ("--version") then
          Version;
        else
          Usage;
        end if;
      end loop;
    else
      Governor.Start;
    end if;
  end Parse_Argv;

begin
  Governor.Start;
end Start_Gov;
  -- TODO: add possibility to start/stop logging
  -- TODO: add possibility to exit application
  -- TODO: add possibility to change lo_temp/hi_temp
