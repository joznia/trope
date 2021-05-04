# space
## apt/dpkg wrapper written in Perl and with a pacman syntax
### Installation
~~~
git clone https://github.com/joznia/space.git
cd space
chmod +x install.pl
sudo ./install.pl # run with -u flag to uninstall
~~~
### Usage
* `-S`: install a package
* `-U`: install a .deb file
* `-Rs`: remove a package
* `-Rsc`: remove a package and run -Qtdq or autoremove
* `-Sy`: sync the repositories
* `-Syu`: perform a system upgrade
* `-Syuu`: perform a distribution upgrade
* `-A`: add an apt repo (e.g. a PPA)
* `-Ra`: remove an apt repo
* `-Ss`: search for a package via regex
* `-Q`: search for a locally installed package
* `-Qi`: display installed package information
* `-Si`: display remote package information
* `-Ql`: display files provided by an installed package
* `-Fl`: display files provided by a remote package (requires 'apt-file')
* `-Qo`: find which package provides which file
* `-Qc`: show the changelog of a package
* `-Qu`: list packages which are upgradable
* `-Sc`: remove now-undownloadable packages from the local package cache
* `-Scc`: remove all downloaded packages from the local package cache
* `-Qtdq`: remove orphan packages
* `-De`: mark an automatically installed package as manually installed
* `-Dd`: mark a manually installed package as automatic
* `-Sw`: download a package without installing it
* `-Qmq`: remove packages not included in any repositories (requires 'aptitude')
* `-Cu`: update the local package file cache (requires 'apt-file')


