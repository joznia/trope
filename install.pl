#!/usr/bin/env perl

use File::Copy;

$src = "./main.pl";
$dest = "/usr/bin/space";

$a = $ARGV[0];
if ($a eq '-u') {
    if (-e $dest) {
        unlink $dest or die "uninstall failed: $! \n";
    }
} else {
    copy $src, $dest or die "install failed: $! \n";
    chmod 0755, $dest;
}
