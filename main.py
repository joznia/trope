#!/usr/bin/env python3

# Welcome to TROPE.
# This is a MacPorts wrapper written in Python and aims to have a syntax similar to Arch's 'pacman'.
# This is free software licensed under the GNU GPL v3.

import sys
import os

helpdoc = '''trope: --help
-S     : install a port
-C     : clean working files used to install a port
-Cc    : clean ALL files used to install a port
-Rs    : uninstall a port
-Rns   : uninstall a port (same as -Rs)
-Rsc   : uninstall a port + dependents (!)
-Sy    : sync the ports tree
-Syu   : upgrade all installed ports (also runs -Sy first)
-Ss    : search for a port via regex
-Ssg   : search for a port via glob
-Sse   : search for a port via exact name
-Q     : list installed ports
-Qi    : display info about a port
-Si    : display info about a port (same as -Qi)
-Ql    : display files provided by an installed port
-Qu    : list ports which are upgradable
-Sc    : clean (-C) all installed ports 
-Scc   : fullclean (-Cc) all installed ports
-Qtdq  : uninstall orphan ports
-c     : uninstall orphan ports (same as -Qtdq)
-De    : mark an automatically installed port as manually installed
-Dd    : mark a manually installed port as automatic
-Sw    : download a port without installing it'''

## Identifying command-line arguments
try:
    opt = str(sys.argv[1])
except IndexError:
    opt = ''
after = ' '.join(sys.argv[2:])

## Command to run when managing packages/ports
pre = "port -v"
prea = "port" # used for some commands

## Check if user is root
if os.geteuid() != 0:
    sys.exit(f"error: not running as root")

## Defining functions
# no arguments or --help
def help(): 
    sys.exit(helpdoc)

# no arguments for option
def checkargs(mis="port(s)"): 
    if not mis:
        pass
    if not after:
        sys.exit(f"no {mis} given")

# -S
def S(): 
    checkargs()
    cmd = f"{pre} install {after}"
    os.system(cmd)

# -C
def C(): 
    checkargs()
    cmd = f"{pre} clean {after}"
    os.system(cmd)

# -Cc
def Cc(): 
    checkargs()
    cmd = f"{pre} clean --all {after}"
    os.system(cmd)

# -Rs
def Rs(): 
    checkargs()
    cmd = f"{pre} uninstall --follow-dependencies {after}"
    os.system(cmd)

# -Rsc
def Rsc(): 
    checkargs()
    cmd = f"{pre} uninstall --follow-dependencies --follow-dependents {after} && {pre} uninstall leaves"
    os.system(cmd)

# -Sy
def Sy():
    cmd = f"{pre} selfupdate"

# -Syu
def Syu(): 
    cmd = f"{pre} sync && {pre} upgrade outdated"
    os.system(cmd)

# -Ss
def Ss():
    checkargs()
    cmd = f"{pre} search --regex {after}"
    os.system(cmd)

# -Ssg
def Ssg():
    checkargs()
    cmd = f"{pre} search --glob {after}"
    os.system(cmd)

# -Sse
def Sse():
    checkargs()z
    cmd = f"{pre} search --exact {after}"
    os.system(cmd)

# -Q
def Q():
    if not after:
        cmd = f"{prea} echo installed"
        os.system(cmd)
    else:
        cmd = f"{prea} installed {after}"
        os.system(cmd)

# -Qi
def Qi():
    checkargs()
    cmd = f"{pre} info {after}"
    os.system(cmd)

# -Ql
def Ql():
    checkargs()
    cmd = f"{pre} contents {after}"
    os.system(cmd)

# -Qu
def Qu():
    cmd = f"{pre} outdated"
    os.system(cmd)

# -Sc
def Sc():
    cmd = f"{pre} clean installed"
    os.system(cmd)

# -Scc
def Scc():
    cmd = f"{pre} clean --all installed"
    os.system(cmd)

# -Qtdq
def Qtdq():
    cmd = f"{pre} uninstall leaves"
    os.system(cmd)

# -De
def De():
    checkargs()
    cmd = f"{pre} setrequested {after}"
    os.system(cmd)

# -Dd
def Dd():
    checkargs()
    cmd = f"{pre} setunrequested {after}"
    os.system(cmd)

## Processing arguments
if not opt:
    help()
elif opt == '--help':
    help() 
elif opt == '-S':
    S() 
elif opt == '-U':
    U() 
elif opt == '-C':
    C() 
elif opt == '-Cc':
    Cc() 
elif opt == '-Rs':
    Rs() 
elif opt == '-Rns':
    Rs() 
elif opt == '-Rsc':
    Rsc() 
elif opt == '-Sy':
    Sy() 
elif opt == '-Syu':
    Syu() 
elif opt == '-Ss':
    Ss() 
elif opt == '-Q':
    Q() 
elif opt == '-Qi':
    Qi() 
elif opt == '-Si':
    Qi() 
elif opt == '-Ql':
    Ql() 
elif opt == '-Qu':
    Qu() 
elif opt == '-Sc':
    Sc() 
elif opt == '-Scc':
    Scc() 
elif opt == '-Qtdq':
    Qtdq() 
elif opt == '-c':
    Qtdq() 
elif opt == '-De':
    De() 
elif opt == '-Dd':
    Dd() 
else: 
    print("unknown argument ") 
