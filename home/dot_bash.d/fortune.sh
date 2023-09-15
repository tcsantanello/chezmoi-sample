
test ! -f cowfortune.sh -a ! -x cowfortune.sh -a -x "$( which fortune 2>/dev/null )" && fortune
