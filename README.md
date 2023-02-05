# Ubuntu Cloud OVA on Windows with Virtualbox

# Requirements

* Ubuntu Linux 22.04 for OVA generation.
* Windows 11 + Virtualbox 6 to run the OVA.
# Install

Download desired Ubuntu Linux cloud image (OVA format):

```bash
wget https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.ova
```

Install tools to create Cloud Init ISO

```bash
sudo apt install cloud-image-utils; # to create cloud init iso
sudo apt install zip;               # compression
sudo apt install whois;             # for mkpasswd
sudo apt install dos2unix;          # for chaging new line endings
```

# Usage

Edit the virtualbox.tpl file for changing VM name, and build.sh for your SSH key.

Generate the `.iso` and `.bat` files:

```bash
./build.sh # To generate ./dist/*.*
```

Copy the `.ova` you download previously and `dist/*.*` files to a local 
Windows folder and then execute the virtualbox.bat => startup.bat scripts.
You can modify the `publish.sh` script for the copy operation.

Optionally add 'startup.bat' to Windows Startup Programs (auto start on reboot).

# Debugging

Uncomment in `build.sh` the following line to inspect the files packaged into `cloud-init.iso`:
```bash
rm -f *-data   # uncomment to debug *-data file content
```

# References

* https://cloud-images.ubuntu.com/
* https://cloud-images.ubuntu.com/focal/current/
* https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.ova
* https://cloudinit.readthedocs.io/en/latest/topics/examples.html
* https://www.virtualbox.org/manual/ch08.html#vboxmanage-modifyvm-networking
* https://gist.github.com/AugustoCiuffoletti/e0af693878e8fa9ab5b6e8d761eb9eec
