
if test -n "$( which mcfly 2>/dev/null )"; then
  source <( mcfly init ${SHELL##*/} )
  export MCFLY_RESULTS=100
  export MCFLY_INTERFACE_VIEW=BOTTOM
fi
