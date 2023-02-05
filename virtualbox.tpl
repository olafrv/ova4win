set VMNAME=mynewvm
set VBDIR=D:\Virtualbox
set VMDIR=%VBDIR%\%VMNAME%
set VMNIC=Realtek PCIe GbE Family Controller #2
set VMOVA=jammy-server-cloudimg-amd64.ova
set VMIMG=ubuntu-jammy-22.04-cloudimg.vdi
set PATH=%PATH%;"C:\Program Files\Oracle\VirtualBox"

mkdir %VMDIR%

VBoxManage import "%VMOVA%" --options importtovdi --vsys 0 --vmname "%VMNAME%"
VBoxManage movevm "%VMNAME%" --folder "%VBDIR%"

VBoxManage modifymedium disk "%VMDIR%\%VMIMG%" --move "%VMDIR%\%VMNAME%-root.vdi" --setlocation "%VMDIR%\%VMNAME%-root.vdi"
VBoxManage modifymedium disk "%VMDIR%\%VMNAME%-root.vdi" --resize=20000

VBoxManage modifyvm "%VMNAME%" --cpus 2 --memory 3096
VBoxManage modifyvm "%VMNAME%" --nic1 bridged
Vboxmanage list bridgedifs 
VBoxManage modifyvm "%VMNAME%" --bridgeadapter1 "%VMNIC%"
VBoxManage modifyvm "%VMNAME%" --audio none --graphicscontroller vmsvga
VBoxManage storagectl "%VMNAME%" --name Floppy --remove
VBoxManage storageattach "%VMNAME%" --storagectl IDE --port 0 --device 0 --type dvddrive --medium cloud-init.iso

@rem 2nd disk requires implementation in build.sh >> user-data based on: 
@rem https://cloudinit.readthedocs.io/en/latest/reference/examples.html#disk-setup
@rem VBoxManage createmedium disk --filename="%VMDIR%\%VMNAME%.vdi" --size=20000 --format=VDI --variant=Standard
@rem VBoxManage storagectl "%VMNAME%" --name SATA --add sata --controller IntelAHCI --hostiocache=on
@rem VBoxManage storageattach "%VMNAME%" --storagectl SATA --device 0 --port 0 --type hdd --medium "%VMDIR%\%VMNAME%.vdi"

VBoxManage startvm "%VMNAME%" --type "headless"

pause
