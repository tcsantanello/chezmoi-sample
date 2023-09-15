
__emacs=$( which emacs )
__emacsclient=$( which emacsclient )

emacs() {
    if ! $( which emacsclient ) --eval '(daemonp)' >& /dev/null; then
          ${__emacs} --daemon &
    fi

    case "$@" in
        *-nw*)
            ${__emacs} "$@";
            ;;
        *)
            ${__emacsclient} -c "$@";
            ;;
    esac
}
