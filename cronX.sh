#! /bin/bash

# If you're doing system ruby.
export RUBYOPT="rubygems"
export GEM_HOME=$HOME/.gem
export GEM_PATH=$GEM_PATH:$HOME/.gem/ruby/1.8.7

# Stupid hack to be able to run gconftool/notify from cron.
# http://ubuntuforums.org/showpost.php?p=7210276

# Get the pid of nautilus
nautilus_pid=$(pgrep -u $LOGNAME -n nautilus)

# If nautilus isn't running, just exit silently
if [ -z "$nautilus_pid" ]; then
  exit 0
fi

# Grab the DBUS_SESSION_BUS_ADDRESS variable from nautilus's environment
eval $(tr '\0' '\n' < /proc/$nautilus_pid/environ | grep '^DBUS_SESSION_BUS_ADDRESS=')

# Check that we actually found it
if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
  echo "Failed to find bus address" >&2
  exit 1
fi

# export it so that child processes will inherit it
export DBUS_SESSION_BUS_ADDRESS

#echo "$@"
$@
