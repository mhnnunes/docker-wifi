docker-wifi  
======================

* This repository contains a set of scripts that, together, get a container up and running on a machine.  

* The script pidbind.sh copies the machine wifi network interface to the container  
    * Basically following [this tutorial](https://github.com/fgg89/docker-ap/wiki/Container-access-to-wireless-network-interface).  
* The script run.sh runs the container and calls pidbind on the background.    
