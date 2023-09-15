# -*- Mode: sh -*-

if test -n "$BASH_VERSION"; then
  if test -f "$HOME/.bashrc" -a ! -L "${HOME}/.bashrc"; then
    . "$HOME/.bashrc"
  fi
fi
