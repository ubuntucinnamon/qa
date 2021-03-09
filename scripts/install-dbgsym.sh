#!/usr/bin/env bash
# Install Debug Symbols - For all packages, or specific ones.
# Before reporting bugs to LP, or really anywhere, regardless if you can
# reproduce it or not, it is how we can get the offset so we know what is wrong.

# Check to ensure we are root perms or else we can't do anything.
function check_root() {
  if [ $EUID != 0 ]; then
    echo "Error: To install the debug symbols you must run as root. Exiting."
    exit
  else
    echo "Info: Running as root"
  fi
}

# Add the repo for the ddebs. These are the debug symbol debs.
function add_dbgsym_repo() {
  echo "Info: Removing debug symbol repository file (to prevent huge repo file)."
  sudo rm /etc/apt/sources.list.d/ddebs.list
  echo "Info: Removed debug symbol repository."
  echo "Info: Adding debug symbol repository."
  echo "Note: For some releases, debug symbols for security may not exist."
  printf "deb http://ddebs.ubuntu.com %s main restricted universe multiverse\n" \
    $(lsb_release -cs){,-updates} | \
    sudo tee -a /etc/apt/sources.list.d/ddebs.list
  echo "Info: Installing debug symbol repository keyring."
  sudo apt install ubuntu-dbgsym-keyring -y
  echo "Info: Updating apt caches and repos."
  sudo apt update
}

# Now install the debug symbols.
# If this fails, the ddeb repo isn't synced yet most likely.
# If you need to, manually cherry-pick the broken packages out.
function install_dbgsym() {
  echo "Info: Installing debug symbols for all cinnamon and neccessary packages."
  sudo apt install cinnamon-dbgsym cinnamon-control-center-dbgsym \
    cinnamon-control-center-goa-dbgsym libcinnamon-control-center1-dbgsym \
    libcinnamon-desktop4-dbgsym libcvc0-dbgsym libcinnamon-menu-3-0-dbgsym \
    cinnamon-screensaver-dbgsym libcscreensaver0-dbgsym cinnamon-session-dbgsym \
    cinnamon-settings-daemon-dbgsym cjs-dbgsym libcjs0-dbgsym lightdm-dbgsym \
    liblightdm-gobject-1-0-dbgsym muffin-dbgsym libmuffin0-dbgsym nemo-dbgsym \
    libnemo-extension1-dbgsym nemo-fileroller-dbgsym nemo-font-manager-dbgsym \
    nemo-gtkhash-dbgsym nemo-python-dbgsym slick-greeter-dbgsym libxapp1-dbgsym \

  echo "Info: Done installing all debug symbols."
}

# Main
check_root
add_dbgsym_repo
install_dbgsym
