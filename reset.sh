#!/bin/bash
set -eux

# Reset deconf
dconf reset -f /

# Rollback the snapshot?
rpm-ostree reset

# Restart for the changes to take effect
systemctl reboot