#!/usr/bin/env python
from subprocess import *
from functools import reduce, partial
import sys

LIB = "lib/"
DIR = "test/"

cases = sys.argv[1:]

for case in cases:
    print("Working hard on %s" % case)

    call(["iverilog", "-o", DIR+case, LIB+case+".v", LIB+case+"_test.v"])
    call(["vvp", DIR+case])
