__ps=$( which ps )
ps() {
    if test $# -eq 0; then
        ${__ps} -u $USER -f f
    else
        ${__ps} ${@}
    fi     
}
