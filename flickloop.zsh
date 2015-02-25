#! /usr/bin/env zsh

# flickloop — run flickpapr forever in a sleep loop

sleeptime=${FLICK_INTVL=10m}

print "Refresh interval set to: $sleeptime"

while `true`; do
  #~/gitcontainer/projects/flickpapr/flickpapr.rb
  flickpapr.rb
  sleep $sleeptime
done
