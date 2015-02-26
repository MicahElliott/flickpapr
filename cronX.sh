#! /bin/bash

# Call this from your crontab if you like.

# Note that there’s a new-ish limitation in Ubuntu that disables updating
# desktop things via `cron`. The `cronX` wrapper script (included) works
# around this, so use it to call `flickpapr`.
#
# You can test by simply running `./cronX.sh flickpapr`. If that works, put
# something like these (choose one) in your crontab for rotation (`crontab -e`):
#
#     MAILTO = you@example.com
#
#     @hourly .../cronX.sh .../flickpapr
#
#     # Pomodoro productivity!
#     0,30 * * * * ...
#
#     # Firehose of distraction.
#     0-55/5 * * * * ...

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
