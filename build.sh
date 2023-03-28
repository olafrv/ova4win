#!/bin/bash

 # id format, will be used for hostname and instance id (without domain).
export id=$(echo $RANDOM | md5sum | head -c 6)
export vm="ubuntu-${id}"
export pw=$(echo "ubuntu" | mkpasswd -m sha-512 --rounds=4096 --stdin)
# export pk="$HOME/.ssh/id_ed25519.pub"
export pk="./id_ed25519.pub"
export sk=$(cat $pk)

echo "Custom VM name? (Enter for Auto)"
read vmc

if [ ! -z "$vmc" ]
then
  vm=$vmc
fi

mkdir -p dist
cd dist

cat > meta-data <<EOF
instance-id: $vm
local-hostname: $vm
network:
  version: 2
  ethernets:
    enp0s3:
      dhcp4: true
EOF

cat > user-data <<EOF
#cloud-config
chpasswd:
  expire: false
# ssh_pwauth: true
users:
  - name: ubuntu
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash
    hashed_passwd: "$pw"
    lock_passwd: false
    ssh_authorized_keys:
     - $sk
packages:
  - openssh-server
  - snapd
  - acpid
  - net-tools
package_update: true
package_upgrade: true
package_reboot_if_required: true
runcmd: 
  - [ service, sshd, restart ]
late-commands:
  - ip addr
  - ip route
EOF

sed s/"set VMNAME=.*"/"set VMNAME=$vm"/ ../virtualbox.tpl > virtualbox.bat
unix2dos virtualbox.bat 2>/dev/null

rm -f cloud-init.iso
cloud-localds cloud-init.iso user-data meta-data 
rm -f *-data   # uncomment to debug *-data file content

cat > startup.bat <<EOF
rem Startup of VMS
rem C:\Users\<User>\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup

set PATH=%PATH%;"C:\Program Files\Oracle\VirtualBox"

VBoxManage startvm "$vm" --type "headless"
timeout /t 30
EOF

echo "--- Generated: $(date)" > md5sum.txt
md5sum *.* >> md5sum.txt
echo "--- VM Name: $vm" >> md5sum.txt

cat md5sum.txt

