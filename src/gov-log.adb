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
with Gov.Temperature_IO;
with Ada.Calendar;
package body Gov.Log is

  subtype Hour_Number is Integer range 0 .. 23;
  subtype Minute_Number is Integer range 0 .. 59;
  subtype Second_Number is Integer range 0 .. 59;

  function Date_Stamp return String is
    Current_Time: constant Ada.Calendar.Time := Ada.Calendar.Clock;
    Day_Duration: constant Integer := Integer (Ada.Calendar.Seconds (Date => Current_Time));
    Hour: Hour_Number;
    Hours: Integer;
    Minute: Minute_Number;
    Minutes: Integer;
    Second: Second_Number;
    Seconds: Integer;
  begin
    Seconds := Day_Duration mod 60;
    Second := Second_Number (Seconds);
    Minutes := (Day_Duration - Seconds) mod 3600;
    Minute := Minute_Number (Minutes / 60);
    Hours := (Day_Duration - Seconds - Minutes);
    Hour := Hour_Number (Hours / 3600);
    return  Ada.Calendar.Year_Number'Image (Ada.Calendar.Year (Date => Current_Time)) & '-' &
            Ada.Calendar.Month_Number'Image (Ada.Calendar.Month (Date => Current_Time)) & '-' &
            Ada.Calendar.Day_Number'Image (Ada.Calendar.Day (Date => Current_Time)) & '-' &
            Integer'Image (Hour) & ':' &
            Minute_Number'Image (Minute) & ':' &
            Second_Number'Image (Second);
  end Date_Stamp;

  procedure Log (
    File: in Ada.Text_IO.File_Type;
    CPU: in Gov.Frequency.CPU_Freq;
    Temp: in Gov.Temperature.Temperature) is 
  begin
    Gov.Frequency.CPU_Freq_Write (File => File, Item => CPU);
    Ada.Text_IO.Put (File => File, Item => " ");
    Gov.Temperature_IO.Put (File => File, Item => Temp);
    Ada.Text_IO.New_Line (File => File);
  end Log;

  procedure Open_Log_File (
    File: out Ada.Text_IO.File_Type;
    Name: in String) is
  begin
    Ada.Text_IO.Open (
      File => File,
      Mode => Ada.Text_IO.Append_File,
      Name => Name);

    if not Ada.Text_IO.Is_Open (File => File) then
      Ada.Text_IO.Create (
        File => File,
        Mode => Ada.Text_IO.Append_File,
        Name => Name);
    end if;

    Ada.Text_IO.Put_Line (
      File => File,
      Item => "Logging started:  " & Date_Stamp);
  end Open_Log_File;

  procedure Close_Log_File (
    File: out Ada.Text_IO.File_Type) is
  begin
    Ada.Text_IO.Put_Line (
      File => File,
      Item => "Logging stoped:  " & Date_Stamp);
    Ada.Text_IO.Close (File => File);
  end Close_Log_File;

  procedure Commit_Log (File: out Ada.Text_IO.File_Type) is
    Name: constant String := Ada.Text_IO.Name (File => File);
  begin
    Ada.Text_IO.Close (File => File);
    Ada.Text_IO.Open (File => File, Mode => Ada.Text_IO.Append_File, Name => Name);
  end Commit_Log;

end Gov.Log;
