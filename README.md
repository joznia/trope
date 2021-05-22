# YUMmi
## dnf/rpm wrapper written in Python and with a pacman syntax
### Installation
`install.sh` arguments:
* `-u`: uninstall YUMmi
* `-s`: install as usual, but also symlink `/usr/bin/yummi` to `/usr/bin/pacman`
~~~
git clone https://github.com/joznia/yummi.git
cd yummi
chmod +x install.sh
sudo ./install.sh
~~~
### Usage
* `-S`: install a package
* `-U`: install a local `.rpm`
* `-Rs`: remove a package
* `-Rns`: remove a package (same as -Rs)
* `-Rsc`: remove a package and remove orphans
* `-Sy`: sync the repositories
* `-Syu`: perform a system upgrade
* `-Syuu`: perform a distribution upgrade
* `-Ss`: search for a package via regex
* `-Q`: search for a locally installed package
* `-Qi`: display installed package information
* `-Si`: display remote package information
* `-Ql`: display files provided by an installed package
* `-Fl`: display files provided by a remote package
* `-Qo`: find which package provides which file
* `-Qc`: show the changelog of a package
* `-Qu`: list packages which are upgradable
* `-Sc`: remove now-undownloadable packages from the local package cache
* `-Scc`: remove all downloaded packages from the local package cache
* `-Qtdq`: remove orphan packages
* `-c`: remove orphan packages (same as -Qtdq)
* `-De`: mark an automatically installed package as manually installed
* `-Dd`: mark a manually installed package as automatic
* `-Sw`: download a package without installing it
* `-Qmq`: remove packages not included in any repositories 


