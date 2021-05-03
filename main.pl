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

# no arguments or --help
sub help {
    die $help;
};

# no arguments for option
sub checkargs {
    if($after eq "") {
        die "no package given\n";
    }
}

# test
sub testa {
    print "$after \n";
    print "$#ARGV \n"
}

# -S
sub sync {
    checkargs;
    my $cmd = "sudo apt-get install ${after}";
    system $cmd;
};

# -U
sub debi {
    if(-e $after) {
        my $cmd = "sudo dpkg -i $after || sudo apt-get install -f";
        system $cmd;
    } else {
        die "file '$after' is invalid \n";
    }
};

# -Rs
sub rm {
    checkargs;
    my $cmd = "sudo apt-get remove $after";
    system $cmd;
};

# -Rsc
sub rmc {
    checkargs;
    my $cmd = "sudo apt-get remove $after && sudo apt-get autoremove";
    system $cmd;
}

# -Sy
sub syr {
    my $cmd = "sudo apt-get update";
    system $cmd;
}

# -Syu
sub syu {
    my $cmd = "sudo apt-get update && sudo apt-get upgrade";
    system $cmd;
}

# -Syuu
sub distu {
    my $cmd = "sudo apt-get update && sudo apt-get dist-upgrade";
    system $cmd;
}

# -A
sub addr {
    checkargs;
    my $cmd = "sudo add-apt-repository $after && sudo apt-get update";
    system $cmd;
}

# -Ra
sub rmr {
    checkargs;
    my $cmd = "sudo add-apt-repository --remove $after && sudo apt-get update";
    system $cmd;
}

# -Ss
sub se {
    checkargs;
    my $cmd = "apt-cache search $after";
    system $cmd;
}

# -Q
sub sei {
    if($after eq '') {
        my $cmd = "dpkg -l | awk '/^i/ { print \$2 }'";
        system $cmd;
    } else {
        my $cmd = "dpkg -l | awk '/^i/ { print \$2 }' | grep $after";
        system $cmd;
    }
}

# -Qi
sub seii {
    checkargs;
    my $cmd = "dpkg -s $after";
    system $cmd;
}

# -Si
sub ser {
    checkargs;
    my $cmd = "apt-cache show $after";
    system $cmd;
}

## Processing arguments
if    ($opt eq '-S') { sync }
elsif ($opt eq '-U') { debi }
elsif ($opt eq '-Rs') { rm }
elsif ($opt eq 't') { testa }
else                  { help }
