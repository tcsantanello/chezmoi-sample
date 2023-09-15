source <(/opt/homebrew/bin/brew shellenv)

export PATH=/opt/homebrew/bin:/opt/homebrew/opt/emacs/bin:$PATH
export PATH=$PATH:$HOME/Library/Python/3.10/bin/

test -f /opt/homebrew/etc/bash_completion && source /opt/homebrew/etc/bash_completion
