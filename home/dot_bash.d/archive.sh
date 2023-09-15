# -*- Mode: sh -*-

archive() {
    stat -t "${@}" | awk '{ print "mv "$1" "$1"-"$14 }' | while read line; do
        $line;
    done;
}
