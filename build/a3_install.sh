#!/bin/bash

rm /etc/issue
apt-get purge apache2 apache2-utils apache2-bin -y
systemctl enable nginx

repo_line="deb http://deb.debian.org/debian unstable main non-free contrib"
if ! grep -qF "$repo_line" /etc/apt/sources.list; then
	echo "$repo_line" | sudo tee -a /etc/apt/sources.list > /dev/null
	apt update
else
	echo "Already have debuan unstable main in sources.list."
fi


DEBIAN_FRONTEND=noninteractive apt -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" install openjdk-11-jre openjdk-11-jre-headless  --no-install-recommends

dpkg --add-architecture i386
apt update
apt -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" install libcurl4 --no-install-recommends
apt -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" install wine wine32:i386 --no-install-recommends

cat << EOF > /etc/motd
==============================================================
| Welcome to the A3!
| For help and documentation, please refer to alikebackup.com
|
| Note: type "menu" for the A3 console menu
==============================================================

EOF

if id "alike" &>/dev/null; then
    mkdir -p /etc/systemd/system/getty@tty1.service.d/
    cat << EOF > /etc/systemd/system/getty@tty1.service.d/override.conf
[Service]
ExecStart=
ExecStart=-/sbin/agetty --autologin alike --noclear %I \$TERM
EOF

cat << EOF >> /home/alike/.profile

if [  \$(tty) = "/dev/tty1" ]; then
    /usr/local/sbin/menu
fi

EOF


cat << EOF >> /home/alike/.bashrc
if [ -d "/usr/local/sbin" ] ; then
    PATH="/usr/local/sbin:$PATH"
fi

EOF

usermod -aG sudo alike
echo "alike ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/alike

    # Reload systemd to apply changes
    systemctl daemon-reload

    # Enable the service
    systemctl enable getty@tty1.service

fi


sed -i 's/^#PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config; 
systemctl restart ssh 
echo "Checking out the Alike project"
REPO="https://github.com/alikebackup/a3.git"
TAG=$(git ls-remote --tags --sort=-v:refname $REPO | grep -v '{}' | head -n 1 | sed 's/.*refs\/tags\///')
echo "Getting the latest build (Tag: $TAG)"
git clone -b $TAG --depth 1 $REPO /root/a3
chmod +x /root/a3/build/install.sh; 
echo "Installing Alike software"
cd /root/a3/build/ && ./install.sh -s $TAG; 
