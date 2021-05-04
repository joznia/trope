#!/usr/bin/env perl

=begin
Welcome to SPACE (Syntax of Pacman, Apt Control Environment).

This is an apt/dpkg wrapper written in Perl and aims to have a syntax similar to Arch's 'pacman'.

This is free software licensed under the GNU GPL v3.
=cut

$help = <<"EOF";
space: --help
-S     : install a package
-U     : install a .deb file
-Rs    : remove a package
-Rsc   : remove a package and run -Qtdq or autoremove
-Sy    : sync the repositories
-Syu   : perform a system upgrade
-Syuu  : perform a distribution upgrade
-A     : add an apt repo (e.g. a PPA)
-Ra    : remove an apt repo
-Ss    : search for a package via regex
-Q     : search for a locally installed package
-Qi    : display installed package information
-Si    : display remote package information
-Ql    : display files provided by an installed package
-Fl    : display files provided by a remote package (requires 'apt-file')
-Qo    : find which package provides which file
-Qc    : show the changelog of a package
-Qu    : list packages which are upgradable
-Sc    : remove now-undownloadable packages from the local package cache
-Scc   : remove all downloaded packages from the local package cache
-Qtdq  : remove orphan packages
-De    : mark an automatically installed package as manually installed
-Dd    : mark a manually installed package as automatic
-Sw    : download a package without installing it
-Qmq   : remove packages not included in any repositories (requires 'aptitude')
-Cu    : update the local package file cache (requires 'apt-file')
EOF

## Identifying command-line arguments
$opt = $ARGV[0];
shift @ARGV;
$after = join " ", @ARGV;

## Defining subroutines

# check if user is root
sub checksu {
    my $thisf = (caller(0)) [3];
    if ($> ne 0) {
        die "arg '$_[0]' requires root \n"
    }
}

# check for dependenceis
sub checkdep {
    my $check = `sh -c 'command -v $_[0]'`;
    return $check;
}

# no arguments or --help
sub help {
    die $help;
};

# no arguments for option
sub checkargs {
    if ($_[0] ne '') {
        $mis = $_[0];
    } else {
        $mis = "package(s)"
    }

    if($after eq '') {
        die "no $mis given\n";
    }
}

# -S
sub S {
    checksu '-S';
    checkargs;
    my $cmd = "apt-get install $after";
    system $cmd;
};

# -U
sub U {
    checksu '-U';
    if(-e $after) {
        my $cmd = "dpkg -i $after || apt-get install -f";
        system $cmd;
    } else {
        die "file '$after' is invalid \n";
    }
};

# -Rs
sub Rs {
    checksu '-Rs';
    checkargs;
    my $cmd = "apt-get remove $after";
    system $cmd;
};

# -Rsc
sub Rsc {
    checksu '-Rsc';
    checkargs;
    my $cmd = "apt-get remove $after && apt-get autoremove";
    system $cmd;
}

# -Sy
sub Sy {
    checksu '-Sy';
    my $cmd = "apt-get update";
    system $cmd;
}

# -Syu
sub Syu {
    checksu '-Syu';
    my $cmd = "apt-get update && apt-get upgrade";
    system $cmd;
}

# -Syuu
sub Syuu {
    checksu '-Syuu';
    my $cmd = "apt-get update && apt-get dist-upgrade";
    system $cmd;
}

# -A
sub A {
    checksu '-A';
    checkargs 'repository';
    my $cmd = "add-apt-repository $after && apt-get update";
    system $cmd;
}

# -Ra
sub Ra {
    checksu '-Ra';
    checkargs 'repository';
    my $cmd = "add-apt-repository --remove $after && apt-get update";
    system $cmd;
}

# -Ss
sub Ss {
    checkargs;
    my $cmd = "apt-cache search $after";
    system $cmd;
}

# -Q
sub Q {
    if($after eq '') {
        my $cmd = "dpkg -l | awk '/^i/ { print \$2 }'";
        system $cmd;
    } else {
        my $cmd = "dpkg -l | awk '/^i/ { print \$2 }' | grep $after";
        system $cmd;
    }
}

# -Qi
sub Qi {
    checkargs;
    my $cmd = "dpkg -s $after";
    system $cmd;
}

# -Si
sub Si {
    checkargs;
    my $cmd = "apt-cache show $after";
    system $cmd;
}

# -Ql
sub Ql {
    checkargs;
    my $cmd = "dpkg -L $after";
    system $cmd;
}

# -Fl
sub Fl {
    checkdep 'apt-file' or die "arg -Fl requires 'apt-file' to be installed \n";
    checkargs;
    my $cmd = "apt-file list $after";
    system $cmd;
}

# -Qo
sub Qo {
    checkargs "file(s)";
    my $cmd = "dpkg -S $after";
    system $cmd;
}

# -Qc
sub Qc {
    checkargs;
    my $cmd = "apt-get changelog $after";
    system $cmd;
}

# -Qu
sub Qu {
    checksu '-Qu';
    my $cmd = "apt-get -u upgrade --assume-no";
    system $cmd;
}

# -Sc
sub Sc {
    checksu '-Sc';
    my $cmd = "apt-get autoclean";
    system $cmd;
}

# -Scc
sub Scc {
    checksu '-Scc';
    my $cmd = "apt-get clean";
    system $cmd;
}

# -Qtdq
sub Qtdq {
    checksu '-Qtdq';
    my $cmd = "apt-get autoremove";
    system $cmd;
}

# -De
sub De {
    checksu '-De';
    checkargs;
    my $cmd = "apt-mark manual $after";
    system $cmd;
}

# -Dd
sub Dd {
    checksu '-Dd';
    checkargs;
    my $cmd = "apt-mark auto $after";
    system $cmd;
}

# -Sw
sub Sw {
    checksu '-Sw';
    checkargs;
    my $cmd = "apt-get install --download-only $after";
    system $cmd;
}

# -Qmq
sub Qmq {
    checksu '-Qmq';
    checkdep 'aptitude' or die 'arg -Qmq requires \'aptitude\' to be installed\n';
    checkargs;
    my $cmd = "aptitude purge '~o' $after";
    system $cmd;
}

# -Cu
sub Cu {
    checksu '-Cu';
    checkdep 'apt-file' or die "arg -Cu requires 'apt-file' to be installed \n";
    my $cmd = "sudo apt-file update";
    system $cmd;
}

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
elsif ($opt eq '-A')     { A }
elsif ($opt eq '-Ra')    { Ra }
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
elsif ($opt eq '-Scc')   { Scc }
elsif ($opt eq '-Qtdq')  { Qtdq }
elsif ($opt eq '-De')    { De }
elsif ($opt eq '-Dd')    { Dd }
elsif ($opt eq '-Sw')    { Sw }
elsif ($opt eq '-Qmq')   { Qmq }
elsif ($opt eq '-Cu')    { Cu }
else                     { print "unknown argument \n" }
