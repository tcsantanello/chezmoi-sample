# -*- Mode: sh -*-

mcd() { mkdir "${1}" && cd "${1}"; }

cd() {
    local args="${@}"

    if test -n "${1}" -a "x$( echo "${1}" | sed 's/\.//g' )" = "x"; then
        args=$( echo "${1}" | awk '{ len = length($1) - 1; for( i = 0; i < len; ++i ) { printf( "../" ); } }' )
    elif test "${#@}" -eq 0; then
        args=~
    fi

    builtin cd "${args}"
}
