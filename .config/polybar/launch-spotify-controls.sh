#!/usr/bin/env sh

LOCKDIR=$HOME/.config/polybar/spotify-lock

function cleanup {
  if rmdir $LOCKDIR; then
    echo "Finished"
  else
    echo "Failed to remove lock directory '$LOCKDIR'"
    exit 1
  fi
}

if mkdir $LOCKDIR; then
  #Ensure that if we "grabbed a lock", we release it
  #Works for SIGTERM and SIGINT(Ctrl-C)
  trap "cleanup" EXIT

  echo "Acquired lock, running"

  /usr/bin/env python3 $HOME/.config/polybar/scripts/spotify/py_spotify_listener.py
else
  echo "Could not create lock directory '$LOCKDIR'"
  exit 1
fi

