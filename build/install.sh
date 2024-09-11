#!/bin/bash

silent=false
if [ "$1" = "-s" ]; then
    silent=true
fi
TAG=0
if [ $# -eq 2 ]; then
    TAG=$2
fi

set -e
cd "$(dirname "$0")"

check_os() {
    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        OS_NAME=$ID
        OS_VERSION_ID=$VERSION_ID
	echo "We're a supported os ${VERSION_ID}"
    else
        echo "Unsupported OS (Debian or variant required)"
	echo "Found ${OS_NAME} (${OS_VERSION})"
        exit 1
    fi
}
echo "Checking os now..."
check_os

if [ "$silent" = false ]; then
while true; do
	echo This will install the A3/Alike software locally.
	read -p "Do you want to continue? (y/n): " choice
	case "$choice" in
	    y|Y ) echo "Continuing..."; break;;
	    n|N ) echo "Exiting"; exit 0;;
	    * ) echo "Invalid input. Please enter 'y' or 'n'.";;
	esac
done

USER="alike"
PASS="alike"
ID=1000
if ! getent group $ID > /dev/null; then
	sudo groupadd -g $ID $USER
fi

if ! id $USER > /dev/null 2>&1; then
	useradd -u $ID -g $ID -m $USER
	echo "$USER:$PASS" | sudo chpasswd
	echo "Password for user $USER set to '$PASS'."
else
	echo "User $USER already exists."
fi
fi

if [[ -d "/home/alike/Alike" ]]; then
        echo
        echo "Detected existing Alike installation!"
        echo "Do not reinstall on top of an existing install."
        echo "For upgrades, please use upgrade.sh"
        echo
        exit 1
fi
if [[ -f "/mnt/ads/ads.dat" ]]; then
        echo
        echo "Detected existing ADS (/mnt/ads)"
        echo "Please unmount ADS before running this script!"
        echo
        exit 1
fi


chsh -s /bin/bash alike
mkdir -p /home/alike/.ssh
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDuSfZQYcxOXZzXyqw0US9BSl4qQM1Jf/3WN/tkW50dgSOAMGzUdvYAYjis9pUB8bCu5RI9/WuQ9Apq4/7xYBdYQZUwYmW98hnVjHmo5bQb2RUXWLs6fYmnefstp3sj5X18tSax56pbl/YyAFapU/Yji0EKNzCIq0UDDdileWLXmktN663rok7J0XtDPnKqCzIWIaXBdPXwY+dq2X5TVhUJ4LUwznIj9bUmUjuWBWDoEhesOZYECKO5FPtSavZKw0CgJlySWW7yiFDWqzlnf79PmBF52Z5aGZkZkd9lEFqKsIGUF5ZoGNr4KOiDugmONhtsLhEQZONp7s4yzsQQRQV1 alike@A2" > /home/alike/.ssh/id_rsa.pub
chown alike:alike /home/alike/.ssh/id_rsa.pub

echo "-----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEA7kn2UGHMTl2c18qsNFEvQUpeKkDNSX/91jf7ZFudHYEjgDBs
1Hb2AGI4rPaVAfGwruUSPf1rkPQKauP+8WAXWEGVMGJlvfIZ1Yx5qOW0G9kVF1i7
On2Jp3n7Lad7I+V9fLUmseeqW5f2MgBWqVP2I4tBCjcwiKtFAw3YpXli15pLTeut
66JOydF7Qz5yqgsyFiGlwXT18GPnatl+U1YVCeC1MM5yI/W1JlI7lgVg6BIXrDmW
BAijuRT7Umr2SsNAoCZckllu8ohQ1qs5Z3+/T5gRedmeWhmZGZHfZRBairCBlBeW
aBja+Cjog7oJjjYbbC4REGTjae7OMs7EEEUFdQIDAQABAoIBAQCjtzc/JOI82T5g
WIQV8c1Yu2KU/y7MF97rpkzXN8ZrtgURFrQ/CXic7N7pnwTjcA2nLAVrh8i2r6TU
qc7IQe/oGC8LLh+e8E5llP0lWKR1GaHPB4yjdAr2gO1dAZuuHwcnfkKWqoc2JOLm
marw7ZnH8+38ucxjqeBhZ8r4bbzGSY2LYGcdkZ33Oc09UPKB8PUH/nCDRtDXoG4G
J+lKc8FhqmWAjtRgulgNxJbfq/cTWXnTAlHh8K2UUSgft+Q3sbBV1vUFGbaJ/ks8
GUqH/MUotLq8U39MmaYptQG9RLJKn4HQ4me33z4HhUYuRo3NTgcgRDQjDgUT7pSF
rAcEzgKlAoGBAPw3hLZBvDn9KN8akxKG+2CYSODYb2JFNWtFee/siFQmy+1z5/r/
8zgmQ5vm1RGyxDJU86u440v30tLJfcqHyIiLa2oaFxjoV+14dv/rV8XgDpM00z2E
++L5nPsAlci0lIW0UDee8WWySoQkjt/k4OVR4bf4qZz/tcPrXfz+u5kTAoGBAPHc
9k6Q/IwWXF125RWJ11muikomqW/zMq7M3ihuM0TD1cXW1eSA2uspUZP3D0uXKNqe
+7QKjj+Ou6vqZHsme0AgMjqxKqWR5v43JcBdnK9c0jU+utIEtxWPKeDWZuOY70mw
ZQ8qLVIExK2o/YfZDsb2GkSeKezRWRNCvEs77ABXAoGAPsycEL1hXpb4XETDpfNS
GAUS8FkzsqZE3MbZy7F7aGiYkjEv68FbD/oHD4R0PQnj7BxW58ULY1j7d1yQI6OX
fNgqEKsaYStI6Wn7R1GT80MMnf6jMkgwZ517Rswof2bnLDtvVcoPlSDFiQ2JPZpB
nRe8OhCCOwM4gOXT6zCKCV0CgYBn0SP8t2lgLFz7VYShySgh+7SqfYvvXOHdfFzD
2AGzu6fwIvZu/gx6MqMsszjihoDnzqRWNM24ZGkUMylsXyk6bleBL/kRVt5jMoLG
3qfZ8irc5g9FBPcdjvU36HADs+rKo6fNaZpIgXl23XnuLPKV3p+J4qY2W+ozRUsT
tCXqQwKBgFjj4EwAlCtPmrt+tyjrqDPrqZZymyhoDhjit/sp9FWCHSCVizZsP30c
3+9cbCRYZNzRgMgz1gioiDUJJKbyl/Tz1ul0k8bhVN/Rhp8fkoSnXLpExRbsdocO
2A7YBW+nbC3l/ayEeT6PuY9KqdwqPq8x+aP7aOGx6U2BjQqrkRg3
-----END RSA PRIVATE KEY-----
" > /home/alike/.ssh/id_rsa
chown alike:alike /home/alike/.ssh/id_rsa
chmod 600 /home/alike/.ssh/id_rsa




if [ "$silent" = false ]; then
	echo "Updating package list..."
	apt update
	apt-get install -qq -y \
	libc6 cron dos2unix rsyslog python3 samba samba-common samba-common-bin samba-dsdb-modules samba-libs samba-vfs-modules \
	openresolv screen shared-mime-info snmpd sqlite3 msmtp inetutils-ping stunnel sudo traceroute util-linux-locales wget \
	xz-utils pv p7zip p7zip-full \
	parted openssh-client openssh-server openssh-sftp-server openssl net-tools wireguard gdisk bindfs \
	nfs-kernel-server nginx lsb-release lsof lz4 kpartx logrotate mono-complete \
	fuse dos2unix curl apt apt-listchanges apt-utils util-linux-locales util-linux vim gawk php php-fpm php-cli php-cgi php-sqlite3 php-curl php-mbstring --no-install-recommends;
fi

# Now move onto the Alike software 
cp -f ../configs/nginx.conf.etc /etc/nginx/nginx.conf
cp -f ../configs/smb.conf /etc/samba/smb.conf
cp -f ../configs/rsyslog.conf /etc/
cp -f ../configs/a3.logrotate /etc/logrotate.d/a3.engine

PHP_VERSION=$(php -r "echo PHP_VERSION;")
PHP_DIR="/etc/php/${PHP_VERSION%.*}/"
WWWCONF="${PHP_DIR}fpm/pool.d/www.conf"
if [[ -f "$WWWCONF" ]]; then
    sudo sed -i 's/^user = .*/user = alike/' "$WWWCONF"
else
    echo "Configuration file $WWWCONF does not exist."
    exit 1
fi

mkdir -p /home/alike/configs/
mkdir -p /home/alike/certs/
mkdir -p /home/alike/logs/
mkdir -p /usr/local/sbin/
mkdir -p /home/alike/Alike/docroot/
mkdir -p /home/alike/Alike/bin/
mkdir -p /home/alike/Alike/java/
mkdir -p /home/alike/Alike/ext/
mkdir -p /home/alike/Alike/DBs/
mkdir -p /home/alike/Alike/remoteDBs/
mkdir -p /home/alike/Alike/temp/
mkdir -p /home/alike/Alike/agentShare/
mkdir -p /home/alike/Alike/agentShare/repCache
mkdir -p /mnt/instaboot/
mkdir -p /mnt/instaboot/base/xen
mkdir -p /mnt/instaboot/sr/xen
mkdir -p /mnt/ads
mkdir -p /mnt/ods1
ln -sf /mnt/ods1 /mnt/ods
touch /mnt/ads/nods
touch /mnt/ods1/nods

echo $TAG > /home/alike/Alike/build.num

if [[ -f "/usr/local/sbin/goofys" ]]; then
	wget https://github.com/kahing/goofys/releases/download/v0.24.0/goofys -O /usr/local/sbin/goofys
	chmod 755 /usr/local/sbin/goofys
fi

openssl req -x509 -newkey rsa:4096 -keyout /home/alike/certs/privkey.pem -out /home/alike/certs/fullchain.pem -sha256 -days 36500 -nodes -subj "/ST=region/L=City/O=Alike Backup/OU=IT/CN=a3.local"

if ! id ads; then
	useradd -M -s /sbin/nologin ads
fi
echo -e "ads\nads" | smbpasswd -s -a ads
systemctl enable smbd.service
systemctl enable nfs-kernel-server
systemctl enable nginx



echo "Configuring startup scripts"
tee "/etc/systemd/system/a3.service" > /dev/null << EOF
[Unit]
Description=A3 Startup
After=network-online.target
Wants=network-online.target

[Service]
Type=oneshot
ExecStart=/usr/local/sbin/a3.startup

[Install]
WantedBy=multi-user.target
EOF
if ! systemctl is-enabled "a3.service" &>/dev/null; then
	systemctl enable a3.service
fi

echo "/usr/local/sbin/blkfs /mnt/restore fuse nonempty,allow_other,sync_read,x-systemd.automount 0 0" >> /etc/fstab

dpkg -i ../binaries/xapi-xe_1.249.3-2_amd64.deb

if [[ -f "../appliance/alike_crontab" ]]; then
	echo "Installing crontab"
	/usr/bin/crontab -u alike ../appliance/alike_crontab;
	rm ../appliance/alike_crontab;
fi

cp ../configs/nginx.conf /home/alike/configs/
cp ../configs/*.pem /home/alike/certs/
cp -r ../webui/* /home/alike/Alike/docroot/
if [ -d "../hooks" ]; then
	mv -n ../hooks /home/alike/Alike/
fi
cp ../appliance/* /usr/local/sbin/
cp ../binaries/*.dll /usr/local/sbin/
mv ../binaries/BackupScheduler.exe /home/alike/Alike/
wine /home/alike/Alike/BackupScheduler.exe -b 2>/dev/null
cp ../binaries/*.exe /usr/local/sbin/
cp -r ../binaries/java/* /home/alike/Alike/java/
cp ../binaries/abd.dat.7z /home/alike/Alike/ext/
cp -r ../binaries/blkfs /usr/local/sbin/

echo "3.85" > /home/alike/a3.rev

chown -R alike:alike /home/alike
chmod 755 /usr/local/sbin/*
chmod 755 /home/alike/Alike/hooks/*

echo "Setup completed successfully!"
echo "Welcome to the A3" > /etc/issue
echo "Restarting to complete installation."
reboot
