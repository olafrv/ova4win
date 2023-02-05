#!/bin/bash

# sudo apt install smbclient
smbclient '\\ds220.lan\public' -U '%'-N -c 'prompt OFF;recurse ON; mput dist'
