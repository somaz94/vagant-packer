## Vagant & Packer
This is Vagrant and Packer Collection

## Enable Nested Virtualization IN KVM In Linux
- [Enable Netsted](https://ostechnix.com/how-to-enable-nested-virtualization-in-kvm-in-linux/)

## Vagrant Install

```bash
# CentOS/RHEL
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
sudo yum -y install vagrant
sudo yum -y install qemu libvirt libvirt-devel ruby-devel gcc qemu-kvm libguestfs-tools
vagrant plugin install vagrant libvirt
vagrant plugin install vagrant-mutate
vagrant plugin install vagrant-parallels

# Ubuntu/Debian
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install vagrant
sudo apt install -y qemu qemu-kvm libvirt-daemon libvirt-clients bridge-utils virt-manager
vagrant plugin install vagrant libvirt
vagrant plugin install vagrant-mutate
vagrant plugin install vagrant-parallels
```

## Options 
Create a kvm-libirt pool for creating Vagrant VMs, save the /dev/sdb1 disk on the server

```bash
mkfs.xfs /dev/sdb1

mkdir -p /var/lib/libvirt/vagrant

echo "$(blkid /dev/sdb1 -o export | grep ^UUID) /var/lib/libvirt/vagrant xfs default 0 0" >> /etc/fstab

mount -a

virsh pool-define-as --name vagrant --type dir --target /var/lib/libvirt/vagrant

virsh pool-start vagrant

virsh pool-autostart vagrant

virsh pool-list --all
 Name                 State      Autostart
-------------------------------------------
 default              active     yes
 vagrant              active     yes
```

## Packer Install

```bash
# CentOS/RHEL
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
sudo yum -y install packer

# Ubuntu/Debian
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install packer
```


## Reference
- [Vagrant Install](https://developer.hashicorp.com/vagrant/downloads?product_intent=vagrant)
- [Packer Install](https://developer.hashicorp.com/packer/downloads)
- [Enable Netsted](https://ostechnix.com/how-to-enable-nested-virtualization-in-kvm-in-linux/)

