# trope
## MacPorts wrapper written in Python and with a pacman syntax
### Installation
#### One command *(recommended)*
`bash <(curl -SsL https://raw.githubusercontent.com/joznia/trope/master/1shot)`
#### Advanced installation
`install.sh` arguments:
* `-u`: uninstall trope
* `-s`: install as usual, but also symlink `/usr/local/bin/trope` to `/usr/local/bin/pacman`
~~~
git clone https://github.com/joznia/trope.git
cd trope
chmod +x install.sh
sudo ./install.sh
~~~
### Usage
* `-S`: install a port
* `-C`: clean working files used to install a port
* `-Cc`: clean ALL files used to install a port
* `-Rs`: uninstall a port
* `-Rns`: uninstall a port (same as -Rs)
* `-Rsc`: uninstall a port + dependents (!)
* `-Sy`: sync the ports tree
* `-Syu`: upgrade all installed ports (also runs -Sy first)
* `-Ss`: search for a port via regex
* `-Ssg`: search for a port via glob
* `-Sse`: search for a port via exact name
* `-Q`: list installed ports
* `-Qi`: display info about a port
* `-Si`: display info about a port (same as -Qi)
* `-Ql`: display files provided by an installed port
* `-Qu`: list ports which are upgradable
* `-Sc`: clean (-C) all installed ports 
* `-Scc`: fullclean (-Cc) all installed ports
* `-Qtdq`: uninstall orphan ports
* `-c`: uninstall orphan ports (same as -Qtdq)
* `-De`: mark an automatically installed port as manually installed
* `-Dd`: mark a manually installed port as automatic

