
# set PATH so it includes user's private bin if it exists
if test -d "$HOME/bin"; then
   export PATH=$HOME/bin:$PATH
fi

if test -d "${HOME}/.krew"; then
   export PATH="${HOME}/.krew/bin:${PATH}"
fi
