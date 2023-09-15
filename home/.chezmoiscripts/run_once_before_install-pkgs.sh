#!/usr/bin/env bash

set -eou pipefail

# Find the package manager...
: ${MGR:=$(which brew 2>/dev/null)}
: ${MGR:=$(which dnf 2>/dev/null)}
: ${MGR:=$(which yum 2>/dev/null)}
: ${MGR:=$(which apt 2>/dev/null)}
: ${MGR:=$(which apk 2>/dev/null)}
: ${MGR:=$(which apt-get 2>/dev/null)}
: ${MGR:=$(which pacman 2>/dev/null)}

# Convert package manager name to packaging type or id
TYPE=$(case "$(basename "${MGR}")" in
  dnf) echo RPM ;;
  yum) echo RPM ;;
  apt) echo DEB ;;
  apt-get) echo DEB ;;
  pacman) echo PAC ;;
  apk) echo APK ;;
  brew) echo BREW ;;
  *)
    echo "Unknown manager" >&2
    exit 1
    ;;
esac)

case "${TYPE}" in
  RPM)
    sudo ${MGR} makecache && sudo ${MGR} install -y \
      gpg-agent git emacs tmux

    ;;
  DEB)
    sudo ${MGR} update && sudo ${MGR} install -y \
      gpg-agent git emacs tmux

    ;;
  PAC)
    sudo ${MGR} -Sy --needed \
      gnupg git emacs tmux

    ;;
  APK)
    sudo ${MGR} add \
      gpg-agent git emacs tmux

    ;;
  BREW)
    ${MGR} install \
      gpgme git emacs tmux

    ;;
esac
