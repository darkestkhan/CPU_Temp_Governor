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
with Ada.Integer_Text_IO;
package body Gov.Temperature is

  function Read_Temp return Temperature is
    Sensor: Ada.Text_IO.File_Type;
    Sensor_Name: constant String := "/sys/devices/virtual/thermal/thermal_zone0/temp";
    Reading: Integer;
  begin
    Ada.Text_IO.Open (File => Sensor, Name => Sensor_Name, Mode => Ada.Text_IO.In_File);
    Ada.Integer_Text_IO.Get (File => Sensor, Item => Reading);
    Ada.Text_IO.Close (Sensor);
    return Temperature (Float (Reading) / 1_000.0);
  end Read_Temp;

end Gov.Temperature;
