# Alike Backup

This is is an attempt to reforge the final Alike Backup (A3) into the newer, unreleased Alike v7.5.  
The Alike software is now completely open-sourced, and this project intends to carry the project forward.  Older A3 installs should be completely compatible, and existing ADS datastores can be imported.

# Quick Start #
Please use our bootable [ISO installer](https://github.com/alikebackup/a3/raw/main/a3_install.iso) to create your A3.  For a USB installer, you can use [Rufus](https://rufus.ie/en/), [Etcher](https://etcher.balena.io/), or similar tools.

### System Recommendations ###
 - At least 2GB Ram is needed for the A3.  Additional memory can help with performance, but has diminishing returns over ~12GB
 - 16GB+ is needed for the A3 OS and software installation.  More space is good for future-proofing.
 - Sufficient backup storage for your environment
   - Please Note: Storing backups on local disks, or in the same environment you are protecting is not recommended!
   - A NAS or CIFS share is a very wise choice
   - S3-compatible storage is only supported for the ODS (Offsite Vaults)


## Appliance Changes ##
This project is slightly different from the previous Alike / A3 product, which was delivered via an Alpine Linux virtual appliance that ran a debian Docker container that housed the Alike software.
This project's goal is to eliminate the Docker layer, and move the Alike software back to running directly on a Debian OS.  The benefits of this are both performance and simplicity, which in turn makes a much easier system to manage.


## Building from source ##
At present, this project has only been tested on Debian 12.x, but it will likely work on other (modern) Debian based systems. To create the new A3, you can use the Debian "preseed" process, by using the following URL as the script during an automated install. This will provide the base OS and all required packages for Alike to run.  After the installation completes, you will then be prompted to run a single command which will pull the latest build of the Alike software, and install it locally.
### Build Steps ###
1. Boot your system with a Debian 12.x ISO.  Please be sure the sytem has at least 32GB of disk, and 2GB ram minimum.
Use the preseed config:

	https://raw.githubusercontent.com/alikebackup/a3/main/build/a3.cfg

1. Once the base OS install is complete, login as root with the user "alike"  (Please change ASAP)
1. Then follow the steps presented on screen, which at present are:

  curl -s https://raw.githubusercontent.com/alikebackup/a3/main/build/a3_install.sh | bash

1. This will install the Alike software and services, followed by a reboot or two.
1. Once the system is up, and you can see the console menu, add/configure your backup storage (ADS)
1. This can be a local disk, an NFS share, or any locally mounted storage at the mount point: /mnt/ads
1. You may now start the Alike services (from the menu), and proceed to the Web UI

# Final Thoughts #
If you are looking for the final update to the A3 product line, you can find a preserved docker image and the required docker-compose.yml file below.  This is here for archive purposes only, and will not be supported in this project.


Lastly, a very big shout-out to the Quadric Software team for creating such a wonderful backup solution, and of course, for deciding to make it open source at the end.
Additionally, a heartfelt thank you to the whole Quadric team for their assistance with the code migration and many questions.

