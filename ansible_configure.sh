#!/bin/bash


#####################################################################


OS_RELEASE="astra"

HOSTNAME_NEW="dc01.aldpro.ru"
NAME=`awk -F"." '{print $1}' /etc/hostname`

PUBLIC_KEY_SSH=""

IPV4="172.31.32.22"
MASK="255.255.255.0"
GATEWAY="172.31.32.1"
#Domain name
SEARCH="ald.int"
#IP-адрес контроллера домена
NAMESERVERS="172.31.32.6"

###REPOS FOR ASTRA

ASTRA_BASE="http://download.astralinux.ru/astra/frozen/1.7_x86-64/1.7.4/repository-base"
ASTRA_EXT="http://download.astralinux.ru/astra/frozen/1.7_x86-64/1.7.4/repository-extended"

###REPOS FOR RED


#######################################################################################

echo -n "Enter the role (Ansible_main | Ansible_host): "
read ROLE


function Install_for_red {

case $ROLE in

    Ansible_main|ansible_main)


    ;;

    Ansible_host|ansible_host)

    ;;
esac

}


function Install_for_astra {

case $ROLE in

    Ansible_main|ansible_main)

    apt install git ansible -y
    ssh-keygen -t rsa -f /home/deployer/.ssh/id_rsa
    chown -R deployer:deployer /home/deployer/.ssh/
    ;;

    Ansible_host|ansible_host)
    mkdir /home/deployer/.ssh
    chmod 700 /home/deployer/.ssh
    touch /home/deployer/.ssh/authorized_keys
    chmod 600 /home/deployer/.ssh/authorized_keys

    echo "$PUBLIC_KEY_SSH" > /home/deployer/.ssh/authorized_keys
    ;;
esac

}

function Configure_OS_red {

hostnamectl set-hostname $HOSTNAME_NEW 

cat <<EOL > /etc/hosts
$IPV4 $HOSTNAME_NEW $NAME
127.0.1.1 $NAME
EOL

cat <<EOL > /etc/resolv.conf
search $SEARCH
nameserver $NAMESERVERS
EOL

}



function Configure_OS_astra {

cat <<EOL > /etc/apt/sources.list
deb $ASTRA_BASE 1.7_x86-64 main non-free contrib
deb $ASTRA_EXT 1.7_x86-64 main contrib non-free
EOL

hostnamectl set-hostname $HOSTNAME_NEW 

systemctl stop NetworkManager
systemctl disable NetworkManager
systemctl enable networking

cat <<EOL > /etc/network/interfaces
source /etc/network/interfaces.d/*

auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
address $IPV4
netmask $MASK
gateway $GATEWAY
dns-nameservers $NAMESERVERS
dns-search $SEARCH
EOL


cat <<EOL > /etc/resolv.conf
search $SEARCH
nameserver $NAMESERVERS
EOL

cat <<EOL > /etc/hosts
$IPV4 $HOSTNAME_NEW $NAME
127.0.1.1 $NAME
EOL

systemctl restart networking
apt update -y
apt upgrade -y

apt install ssh python3 -y

echo "PubkeyAuthentication yes" >> /etc/ssh/sshd_config
echo "AuthorizedKeysFile .ssh/authorized_keys"  >> /etc/ssh/sshd_config
systemctl restart ssh

useradd -G astra-admin -m -s /bin/bash deployer
echo "deployer ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

}






#########################################################################################





case $OS_RELEASE in

    RED|red|RedOS)
        Configure_OS_red
        Install_for_red
    ;;

    Astra|astra|AstraLinux)
        Configure_OS_astra
        Install_for_astra
    ;;
esac

