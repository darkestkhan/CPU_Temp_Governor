#!/usr/bin/env dash

if ! [ -d ./obj ]
then
  mkdir obj
fi
gprbuild -Pcpu_gov.gpr
