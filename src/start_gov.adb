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
with Gov.Temperature; use Gov.Temperature;
with Gov.Frequency; use Gov.Frequency;
procedure Start_Gov is

  package Temperature_IO is new Ada.Text_IO.Fixed_IO (Temperature);

  type CPU_Array is array (Natural range <>) of CPU_Freq;
  type CPU_Address is array (Natural range <>) of access String;

  CPUs: CPU_Array (0 .. 1);
  CPUs_Addresses: CPU_Address (CPUs'Range);

  Hi_Temp: constant Temperature := 90.000;
  Lo_Temp: constant Temperature := 85.000;
  Temp: Temperature;

begin
  CPUs_Addresses (0) := new String'("/sys/devices/system/cpu/cpu0/cpufreq/");
  CPUs_Addresses (1) := new String'("/sys/devices/system/cpu/cpu1/cpufreq/");
  for I in CPUs'Range loop
  Init_CPU_Freq (This => CPUs (I), Path => CPUs_Addresses (I).all);
  end loop;
  loop
    Temp := Read_Temp;
    if Temp > Hi_Temp then
      for I in CPUs'Range loop
        Actualize_Freq (CPUs (I));
        Dec_Freq (CPUs (I));
      end loop;
    elsif Temp < Lo_Temp then
      for I in CPUs'Range loop
        Actualize_Freq (CPUs (I));
        Inc_Freq (CPUs (I));
      end loop;
    end if;

  --  goto No_Debug_Logs;
    Debug_Logs:
      declare
      begin
        Ada.Text_IO.Put ("Temperature is: ");
        Temperature_IO.Put (Temp);
        Ada.Text_IO.New_Line;
        for I in CPUs'Range loop
          Print_CPU_Freq (This => CPUs (I));
        end loop;
        Ada.Text_IO.New_Line;
      end Debug_Logs;
    <<No_Debug_Logs>>

    delay 3.0;
  end loop;
end Start_Gov;
