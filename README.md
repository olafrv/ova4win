# Ubuntu Cloud OVA on Windows with Virtualbox

# Requirements

* Ubuntu Linux 22.04 for OVA generation.
* Windows 11 + Virtualbox 6 to run the OVA.

# Install

Download desired Ubuntu Linux cloud image (OVA format):

```bash
# See references section for a download link
file="https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.ova"
wget $file -O dist/$(basename $file)
```

Install tools to create Cloud Init ISO

```bash
sudo apt install cloud-image-utils; # to create cloud init iso
sudo apt install zip;               # compression
sudo apt install whois;             # for mkpasswd
sudo apt install dos2unix;          # for chaging new line endings
```

# Usage

Set the SSH Public Key path `$pk` variable in `build.sh`.

Generate the `.iso` and `.bat` files:

```bash
./build.sh # To generate ./dist/*.*
```

Copy the `.ova` you download previously and `dist/*.*` files to a local 
Windows folder and execute first virtualbox.bat.

You can modify the `publish.sh` script for the copy operation (shared drive).

Optionally add 'startup.bat' to Windows Startup Programs (auto start VM on reboot).

# Debugging

Uncomment in `build.sh` the following line to inspect the files packaged into `cloud-init.iso`:
```bash
rm -f *-data   # uncomment to debug *-data file content
```

# References

* https://cloud-images.ubuntu.com/
* https://cloudinit.readthedocs.io/en/latest/topics/examples.html
* https://cloudinit.readthedocs.io/en/latest/reference/modules.html
* https://wiki.archlinux.org/title/Xorg/Keyboard_configuration
* https://www.virtualbox.org/manual/ch08.html#vboxmanage-modifyvm-networking
* https://gist.github.com/AugustoCiuffoletti/e0af693878e8fa9ab5b6e8d761eb9eec
