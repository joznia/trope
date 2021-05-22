#!/usr/bin/env python3

# Welcome to yummi.
# This is a dnf/rpm wrapper written in Python and aims to have a syntax similar to Arch's 'pacman'.
# This is free software licensed under the GNU GPL v3.

import sys
import os

helpdoc = '''yummi: --help
-S     : install a package
-U     : install a local .rpm
-Rs    : remove a package
-Rns   : remove a package (same as -Rs)
-Rsc   : remove a package and remove orphans
-Syu   : perform a system upgrade
-Syuu  : perform a distribution upgrade
-Ss    : search for a package via regex
-Q     : search for a locally installed package
-Qi    : display installed package information
-Si    : display remote package information
-Ql    : display files provided by an installed package
-Fl    : display files provided by a remote package 
-Qo    : find which package provides which file
-Qc    : show the changelog of a package
-Qu    : list packages which are upgradable
-Sc    : remove now-undownloadable packages from the local package cache
-Scc   : remove all downloaded packages from the local package cache
-Qtdq  : remove orphan packages
-c     : remove orphan packages (same as -Qtdq)
-De    : mark an automatically installed package as manually installed
-Dd    : mark a manually installed package as automatic
-Sw    : download a package without installing it
-Qmq   : remove packages not included in any repositories'''

## Identifying command-line arguments
opt = sys.argv[1]
after = sys.argv[2:]

## Defining functions

# check if user is root
def checksu(arg):
    if os.geteuid() != 0:
        sys.exit(f"option {arg} requires root ")

# no arguments or --help
def help(): 
    sys.exit(helpdoc)

# no arguments for option
def checkargs(mis="package(s)"): 
    if not mis:
        pass
    if not after:
        sys.exit(f"no {mis} given")

# -S
def S(): 
    checksu('-S')
    checkargs()
    cmd = f"dnf install {after}"
    os.system(cmd)

# -U
def U():
    checksu('-U')
    if not after: 
        cmd = f"dnf localinstall {after}"
        os.system(cmd)
    else:
        sys.exit(f"file '{after}' is invalid ")

# -Rs
def Rs(): 
    checksu('-Rs')
    checkargs()
    cmd = f"dnf remove {after}"
    os.system(cmd)

# -Rsc
def Rsc(): 
    checksu('-Rsc')
    checkargs()
    cmd = f"dnf remove {after} && dnf autoremove"
    os.system(cmd)


# -Syu
def Syu(): 
    checksu('-Syu')
    cmd = f"dnf upgrade --refresh"
    os.system(cmd)


# -Syuu
def Syuu(): 
    checksu('-Syuu')
    cmd = "dnf distro-sync"
    os.system(cmd)


# -Ss
def Ss():
    checkargs()
    cmd = "dnf search {after}"
    os.system(cmd)

# -Q
def Q():
    if({after} eq '') {
        cmd = f"rpm -qa"
        os.system(cmd)
    } else {
        cmd = f"rpm -qa {after}"
        os.system(cmd)
    }

# -Qi
def Qi():
    checkargs()
    cmd = f"dnf info installed {after}"
    os.system(cmd)

# -Si
def Si():
    checkargs()
    cmd = f"dnf info {after}"
    os.system(cmd)

# -Ql
def Ql():
    checkargs()
    cmd = f"dnf repoquery -l {after}"
    os.system(cmd)

# -Fl
def Fl():
    checkargs()
    cmd = f"dnf repoquery -l {after}"
    os.system(cmd)

# -Qo
def Qo():
    if not after:
        cmd = f"rpm -qf {after}"
        os.system(cmd)
    else:
        sys.exit("file '{after}' invalid ")

# -Qc
def Qc():
    checkargs()
    cmd = f"dnf changelog {after}"
    os.system(cmd)

# -Qu
def Qu():
    cmd = "dnf list updates"
    os.system(cmd)

# -Sc
def Sc():
    checksu('-Sc')
    cmd = "dnf clean all"
    os.system(cmd)

# -Qtdq
def Qtdq():
    checksu('-Qtdq')
    cmd = "dnf autoremove"
    os.system(cmd)

# -De
def De():
    checksu('-De')
    checkargs()
    cmd = "dnf mark install {after}"
    os.system(cmd)

# -Dd
def Dd():
    checksu('-Dd')
    checkargs()
    cmd = f"dnf mark remove {after}"
    os.system(cmd)

# -Sw
def Sw():
    checksu('-Sw')
    checkargs()
    cmd = f"dnf download {after}"
    os.system(cmd)

# -Qmq
def Qmq():
    checksu('-Qmq')
    cmd = f"dnf repoquery --extras"
    os.system(cmd)

## Processing arguments
if    ($opt eq '')       { help }
elsif ($opt eq '--help') { help }
elsif ($opt eq '-S')     { S }
elsif ($opt eq '-U')     { U }
elsif ($opt eq '-Rs')    { Rs }
elsif ($opt eq '-Rns')   { Rs }
elsif ($opt eq '-Rsc')   { Rsc }
elsif ($opt eq '-Sy')    { Sy }
elsif ($opt eq '-Syu')   { Syu }
elsif ($opt eq '-Syuu')  { Syuu }
elsif ($opt eq '-Ss')    { Ss }
elsif ($opt eq '-Q')     { Q }
elsif ($opt eq '-Qi')    { Qi }
elsif ($opt eq '-Si')    { Si }
elsif ($opt eq '-Ql')    { Ql }
elsif ($opt eq '-Fl')    { Fl }
elsif ($opt eq '-Qo')    { Qo }
elsif ($opt eq '-Qc')    { Qc }
elsif ($opt eq '-Qu')    { Qu }
elsif ($opt eq '-Sc')    { Sc }
elsif ($opt eq '-Scc')   { Sc }
elsif ($opt eq '-Qtdq')  { Qtdq }
elsif ($opt eq '-c')     { Qtdq }
elsif ($opt eq '-De')    { De }
elsif ($opt eq '-Dd')    { Dd }
elsif ($opt eq '-Sw')    { Sw }
elsif ($opt eq '-Qmq')   { Qmq }
else                     { print "unknown argument " }
