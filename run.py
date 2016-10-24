#!/usr/bin/env python
from subprocess import *
from functools import reduce, partial
import sys

LIB = "lib/"
DIR = "build/"

call(["mkdir", "-p", "build"])

files = sys.argv[1:]

def run_test(files):
    print("Working hard on %s" % files)

    args = reduce(lambda acc, x:
                  acc + [LIB+x+".v", LIB+x+"_test.v"], files, [])

    call(["iverilog", "-o", DIR+"test"] + args + [LIB+"params.vh"])
    call(["vvp", DIR+"test"])
    call(["rm", DIR+"test"])

run_test(files)
