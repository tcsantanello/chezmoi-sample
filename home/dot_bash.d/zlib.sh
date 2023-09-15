
zlcat() {
  ( printf "\x1f\x8b\x08\x00\x00\x00\x00\x00"; cat "${1}" ) | zcat -dc - 2>/dev/null
}
