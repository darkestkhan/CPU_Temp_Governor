#!/usr/bin/env dash

if ! [ -d ./obj ]
then
  mkdir obj
fi
gprbuild -Pgov.gpr
