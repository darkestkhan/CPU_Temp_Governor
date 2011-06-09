#!/usr/bin/env dash

fallback_compilation () {
  gnatmake -O3 -m64 -mssse3 -march=core2 -fomit-frame-pointer -Wall -gnat05 -gnata -gnatE -gnato -fstack-check src/start_gov.adb
  mv *.ali *.o obj/ 
}

if ! [ -d ./obj ]
then
  mkdir obj
fi

#gprbuild -Pgov.gpr

fallback_compilation
