#!/usr/bin/env perl

=begin
Welcome to yummi.

This is a dnf/rpm wrapper written in Perl and aims to have a syntax similar to Arch's 'pacman'.

This is free software licensed under the GNU GPL v3.
=cut

$help = <<"EOF";
yummi: --help
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
-Qmq   : remove packages not included in any repositories 
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
    my $cmd = "dnf install $after";
    system $cmd;
};

# -U
sub U {
    checksu '-U';
    if(-e $after) {
        my $cmd = "dnf localinstall $after";
        system $cmd;
    } else {
        die "file '$after' is invalid \n";
    }
};

# -Rs
sub Rs {
    checksu '-Rs';
    checkargs;
    my $cmd = "dnf remove $after";
    system $cmd;
};

# -Rsc
sub Rsc {
    checksu '-Rsc';
    checkargs;
    my $cmd = "dnf remove $after && dnf autoremove";
    system $cmd;
}

# -Syu
sub Syu {
    checksu '-Syu';
    my $cmd = "dnf upgrade --refresh";
    system $cmd;
}

# -Syuu
sub Syuu {
    checksu '-Syuu';
    my $cmd = "dnf distro-sync";
    system $cmd;
}

# -Ss
sub Ss {
    checkargs;
    my $cmd = "dnf search $after";
    system $cmd;
}

# -Q
sub Q {
    if($after eq '') {
        my $cmd = "rpm -qa";
        system $cmd;
    } else {
        my $cmd = "rpm -qa $after";
        system $cmd;
    }
}

# -Qi
sub Qi {
    checkargs;
    my $cmd = "dnf info installed $after";
    system $cmd;
}

# -Si
sub Si {
    checkargs;
    my $cmd = "dnf info $after";
    system $cmd;
}

# -Ql
sub Ql {
    checkargs;
    my $cmd = "dnf repoquery -l $after";
    system $cmd;
}

# -Fl
sub Fl {
    checkargs;
    my $cmd = "dnf repoquery -l $after";
    system $cmd;
}

# -Qo
sub Qo {
    if (-e $after) {
        my $cmd = "rpm -qf $after";
        system $cmd;
    } else {
        die "file '$after' invalid \n"
    }
}

# -Qc
sub Qc {
    checkargs;
    my $cmd = "dnf changelog $after";
    system $cmd;
}

# -Qu
sub Qu {
    my $cmd = "dnf list updates";
    system $cmd;
}

# -Sc
sub Sc {
    checksu '-Sc';
    my $cmd = "dnf clean all";
    system $cmd;
}

# -Qtdq
sub Qtdq {
    checksu '-Qtdq';
    my $cmd = "dnf autoremove";
    system $cmd;
}

# -De
sub De {
    checksu '-De';
    checkargs;
    my $cmd = "dnf mark install $after";
    system $cmd;
}

# -Dd
sub Dd {
    checksu '-Dd';
    checkargs;
    my $cmd = "dnf mark remove $after";
    system $cmd;
}

# -Sw
sub Sw {
    checksu '-Sw';
    checkargs;
    my $cmd = "dnf download $after";
    system $cmd;
}

# -Qmq
sub Qmq {
    checksu '-Qmq';
    my $cmd = "dnf repoquery --extras";
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
else                     { print "unknown argument \n" }
