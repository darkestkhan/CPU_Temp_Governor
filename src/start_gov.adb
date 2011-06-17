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
with Gov.Log;
procedure Start_Gov is

  type CPU_Array is array (Natural range <>) of Gov.Frequency.CPU_Freq;
  type CPU_Address is array (Natural range <>) of access String;

  Log_File: Ada.Text_IO.File_Type;

  CPUs: CPU_Array (0 .. 1);
  CPUs_Addresses: CPU_Address (CPUs'Range);

  Hi_Temp: constant Gov.Temperature.Temperature := 90.000;
  Lo_Temp: constant Gov.Temperature.Temperature := 85.000;
  Temp: Gov.Temperature.Temperature;

begin
  CPUs_Addresses (0) := new String'("cpu0");
  CPUs_Addresses (1) := new String'("cpu1");
  for I in CPUs'Range loop
    Gov.Frequency.Init_CPU_Freq (This => CPUs (I), Path => CPUs_Addresses (I).all);
  end loop;
  Gov.Log.Open_Log_File (File => Log_File, Name => "cpu_temp_gov.log");
  -- TODO: add possibility to start/stop logging
  -- TODO: add possibility to exit application
  -- TODO: add possibility to change lo_temp/hi_temp

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

  --  goto No_Debug_Logs;
    Debug_Logs:
      declare
      begin
        Ada.Text_IO.Put ("Temperature is: ");
        Gov.Temperature_IO.Put (Temp);
        Ada.Text_IO.New_Line;
        for I in CPUs'Range loop
          Gov.Frequency.Print_CPU_Freq (This => CPUs (I));
          Gov.Log.Log (File => Log_File, CPU => CPUs (I), Temp => Temp);
        end loop;
        Ada.Text_IO.New_Line;
      end Debug_Logs;
    <<No_Debug_Logs>>
    Ada.Text_IO.Close (File => Log_File);
    Ada.Text_IO.Open (File => Log_File, Mode => Ada.Text_IO.Append_File, Name => "cpu_temp_gov.log");
    delay 3.0;
  end loop;
  Gov.Log.Close_Log_File (File => Log_File);
end Start_Gov;
