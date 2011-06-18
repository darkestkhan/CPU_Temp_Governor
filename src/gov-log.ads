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
with Gov.Frequency;
with Gov.Temperature;
package Gov.Log is

  procedure Log (
    File: in Ada.Text_IO.File_Type;
    CPU: in Gov.Frequency.CPU_Freq;
    Temp: in Gov.Temperature.Temperature);

  procedure Open_Log_File (
    File: out Ada.Text_IO.File_Type;
    Name: in String);

  procedure Close_Log_File (File: out Ada.Text_IO.File_Type);

  procedure Commit_Log (File: out Ada.Text_IO.File_Type);

end Gov.Log;
