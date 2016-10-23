#!/usr/bin/env python
from subprocess import *
from functools import reduce, partial
import sys

LIB = "lib/"
DIR = "build/"

cases = sys.argv[1:]

call(["mkdir", "-p", "build"])

for case in cases:
    print("Working hard on %s" % case)

    call(["iverilog", "-o", DIR+case, LIB+case+".v", LIB+case+"_test.v"])
    call(["vvp", DIR+case])
    call(["rm", DIR+"*"])
