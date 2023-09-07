#remove network mac and interface information
#sed -i '/HWADDR/d' /etc/sysconfig/network-scripts/ifcfg-eth0
#sed -i "/^UUID/d" /etc/sysconfig/network-scripts/ifcfg-eth0
#echo "DEVICE=eth0" >> /etc/sysconfig/network-scripts/ifcfg-eth0

# Clean up network interface persistence
rm -f /etc/udev/rules.d/70-persistent-net.rules;
mkdir -p /etc/udev/rules.d/70-persistent-net.rules;
rm -f /lib/udev/rules.d/75-persistent-net-generator.rules;
rm -rf /dev/.udev/;

for ndev in `ls -1 /etc/sysconfig/network-scripts/ifcfg-*`; do
    if [ "`basename $ndev`" != "ifcfg-lo" ]; then
        sed -i '/^HWADDR/d' "$ndev";
        sed -i '/^UUID/d' "$ndev";
    fi
done

#disable selinux
rm /etc/sysconfig/selinux
ln -s /etc/selinux/config /etc/sysconfig/selinux
sed -i "s/^\(SELINUX=\).*/\1disabled/g" /etc/selinux/config

#remove any ssh keys or persistent routes, dhcp leases
rm -f /etc/ssh/ssh_host_*
rm -f /var/lib/dhclient/dhclient-eth0.leases
rm -rf /tmp/*
yum -y clean all

#disable reverse dns lookups on sshd
echo "UseDNS no" >> /etc/ssh/sshd_config
