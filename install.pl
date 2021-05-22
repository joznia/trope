#!/usr/bin/env perl

use File::Copy;

$src = "./main.py";
$dest = "/usr/bin/yummi";
$destp = "/usr/bin/pacman";

sub base {
    copy $src, $dest or die "install failed: $! \n";
    chmod 0755, $dest;
}

$a = $ARGV[0];
if ($a eq '-u') {
    if (-e $dest) {
        unlink $dest or die "uninstall failed: $! \n";
    }
} elsif ($a eq '-s') {
    base;
    symlink $dest, $destp;
    chmod 0755, $destp;
} else {
    base;
}
