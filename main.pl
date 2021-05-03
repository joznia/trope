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
-Fl    : display files provided by a remote package
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
EOF

## Identifying command-line arguments
$opt = $ARGV[0];
shift @ARGV;
$after = join " ", @ARGV;

## Defining subroutines

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
    checkargs;
    my $cmd = "sudo apt-get install $after";
    system $cmd;
};

# -U
sub U {
    if(-e $after) {
        my $cmd = "sudo dpkg -i $after || sudo apt-get install -f";
        system $cmd;
    } else {
        die "file '$after' is invalid \n";
    }
};

# -Rs
sub Rs {
    checkargs;
    my $cmd = "sudo apt-get remove $after";
    system $cmd;
};

# -Rsc
sub Rsc {
    checkargs;
    my $cmd = "sudo apt-get remove $after && sudo apt-get autoremove";
    system $cmd;
}

# -Sy
sub Sy {
    my $cmd = "sudo apt-get update";
    system $cmd;
}

# -Syu
sub Syu {
    my $cmd = "sudo apt-get update && sudo apt-get upgrade";
    system $cmd;
}

# -Syuu
sub Syuu {
    my $cmd = "sudo apt-get update && sudo apt-get dist-upgrade";
    system $cmd;
}

# -A
sub A {
    checkargs;
    my $cmd = "sudo add-apt-repository $after && sudo apt-get update";
    system $cmd;
}

# -Ra
sub Ra {
    checkargs;
    my $cmd = "sudo add-apt-repository --remove $after && sudo apt-get update";
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
    checkdep 'apt-file' or die 'arg -Qmq requires \'aptitude\' to be installed\n';
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
    my $cmd = "sudo apt-get -u upgrade --assume-no";
    system $cmd;
}

# -Sc
sub Sc {
    my $cmd = "sudo apt-get autoclean";
    system $cmd;
}

# -Scc
sub Scc {
    my $cmd = "sudo apt-get clean";
    system $cmd;
}

# -Qtdq
sub Qtdq {
    my $cmd = "sudo apt-get autoremove";
    system $cmd;
}

# -De
sub De {
    checkargs;
    my $cmd = "sudo apt-mark manual $after";
    system $cmd;
}

# -Dd
sub Dd {
    checkargs;
    my $cmd = "sudo apt-mark auto $after";
    system $cmd;
}

# -Sw
sub Sw {
    checkargs;
    my $cmd = "sudo apt-get install --download-only $after";
    system $cmd;
}

# -Qmq
sub Qmq {
    checkdep 'aptitude' or die 'arg -Qmq requires \'aptitude\' to be installed\n';
    checkargs;
    my $cmd = "sudo aptitude purge '~o' $after";
    system $cmd;
}

## Processing arguments
if    ($opt eq '')      { help }
elsif ($opt eq '-S')    { S }
elsif ($opt eq '-U')    { U }
elsif ($opt eq '-Rs')   { Rs }
elsif ($opt eq '-Rsc')  { Rsc }
elsif ($opt eq '-Sy')   { Sy }
elsif ($opt eq '-Syu')  { Syu }
elsif ($opt eq '-Syuu') { Syuu }
elsif ($opt eq '-A')    { A }
elsif ($opt eq '-Ra')   { Ra }
elsif ($opt eq '-Ss')   { Ss }
elsif ($opt eq '-Q')    { Q }
elsif ($opt eq '-Qi')   { Qi }
elsif ($opt eq '-Si')   { Si }
elsif ($opt eq '-Ql')   { Ql }
elsif ($opt eq '-Fl')   { Fl }
elsif ($opt eq '-Qo')   { Qo }
elsif ($opt eq '-Qc')   { Qc }
elsif ($opt eq '-Qu')   { Qu }
elsif ($opt eq '-Sc')   { Sc }
elsif ($opt eq '-Scc')  { Scc }
elsif ($opt eq '-Qtdq') { Qtdq }
elsif ($opt eq '-De')   { De }
elsif ($opt eq '-Dd')   { Dd }
elsif ($opt eq '-Sw')   { Sw }
elsif ($opt eq '-Qmq')  { Qmq }
else                    { print 'unknown argument' }
