#!/bin/sh
# SPDX-License-Identifier: GPL-3.0-only
#
# This file is part of the distrobox project:
#    https://github.com/89luca89/distrobox
#
# Copyright (C) 2021 distrobox contributors
#
# distrobox is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License version 3
# as published by the Free Software Foundation.
#
# distrobox is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with distrobox; if not, see <http://www.gnu.org/licenses/>.

# Print usage to stdout.
# Arguments:
#   None
# Outputs:
#   print usage with examples.
show_help() {
	cat <<EOF
Usage:

	distrobox-terminal-profile -n PROFILE_NAME -s SHORTCUT -c CONTAINER_NAME

Options:

	--name/-n:		user name
	--shortcut/-s:		keyboard shortcut eg: <Super>Enter, <Alt>s, <Primary><Alt>t
	--container/-c:		container name
EOF
}

# Parse arguments
while :; do
	case $1 in
	-h | --help)
		# Call a "show_help" function to display a synopsis, then exit.
		show_help
		exit 0
		;;
	-n | --name)
		if [ -n "$2" ]; then
			PROFILE_NAME="$2"
			shift
			shift
		fi
		;;
	-s | --shortcut)
		if [ -n "$2" ]; then
			KEYS_SHORTCUT="$2"
			shift
			shift
		fi
		;;
	-c | --container)
		if [ -n "$2" ]; then
			CONTAINER_NAME="$2"
			shift
			shift
		fi
		;;
	*) # Default case: If no more options then break out of the loop.
		break ;;
	esac
done

set -o errexit
set -o nounset

PROFILE_UUID=$(cat /proc/sys/kernel/random/uuid)

# Gemerate the dconf file for terminal profile
DCONF_PROFILE=$(dconf dump /org/gnome/terminal/legacy/profiles:/)
DCONF_PROFILE=$(echo "$DCONF_PROFILE" | sed "s|list=\[|list=\['$PROFILE_UUID',|g")
DCONF_PROFILE="$DCONF_PROFILE

[:$PROFILE_UUID]
background-color='rgb(32,32,32)'
bold-is-bright=true
custom-command='$(command -v distrobox-enter) -n $CONTAINER_NAME'
font='Monospace 10'
foreground-color='rgb(255,255,255)'
scrollbar-policy='never'
use-custom-command=true
use-system-font=true
use-theme-colors=false
visible-name='$PROFILE_NAME'
"

echo "$DCONF_PROFILE" > /tmp/dconf.conf

dconf load /org/gnome/terminal/legacy/profiles:/ < /tmp/dconf.conf

DCONF_KEYS=$(dconf dump /org/gnome/settings-daemon/plugins/media-keys/)
KEYS_INDEX=$(echo "$DCONF_KEYS" | grep -Eo "[0-9]+" | sort -u | tail -n 1)
KEYS_INDEX=$((KEYS_INDEX + 1))

DCONF_KEYS=$(echo "$DCONF_KEYS" | sed "s|custom-keybindings=\[|custom-keybindings=\['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom$KEYS_INDEX/',|g")
DCONF_KEYS="$DCONF_KEYS

[custom-keybindings/custom$KEYS_INDEX]
binding='$KEYS_SHORTCUT'
command='gnome-terminal --tab-with-profile=$PROFILE_NAME'
name='Gnome Terminal - $PROFILE_NAME'
"

echo "$DCONF_KEYS" > /tmp/dconf.conf

dconf load /org/gnome/settings-daemon/plugins/media-keys/ < /tmp/dconf.conf

rm /tmp/dconf.conf