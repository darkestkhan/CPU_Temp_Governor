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
package Gov.Frequency is

  type Freq_Step is (First, Second, Third, Fourth);

  type Pathname is access String;

  type CPU_Freq is
  record
    Path: Pathname;
    Min: Freq_Step;
    Max: Freq_Step;
  end record;

  Core_Meltdown: exception;

  function Freq_Step_Image (This: in Freq_Step) return String;

  function Create_Pathname (From: in String) return Pathname;

  procedure Dec_Freq (This: in out CPU_Freq);
  procedure Inc_Freq (This: in out CPU_Freq);

  function Get_Min_Freq (This: in CPU_Freq) return Freq_Step;
  function Get_Max_Freq (This: in CPU_Freq) return Freq_Step;

  procedure Init_CPU_Freq (This: in out CPU_Freq; Path: in String);

  procedure Print_CPU_Freq (This: in CPU_Freq);

  procedure Actualize_Freq (This: in out CPU_Freq);

end Gov.Frequency;
