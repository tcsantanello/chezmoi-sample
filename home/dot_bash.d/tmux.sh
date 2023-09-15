
alias tmux="tmux -2"
alias ltmux="if tmux has; then tmux -2 attach; else tmux -2 new; fi"
alias ntmux='
  _ntmux() {
    if ! tmux has; then tmux -2;
    elif tmux list-sessions | grep . >& /dev/null; then tmux new-session -t "${1:-0}";
    else tmux -2 ; fi
  };
  _ntmux
'

PARENT=$( ps -eo pid,comm | awk '$1 = '$PPID' { print $2 }' )

if test -n "${TERM%screen*}" \
    -a -n "${TERM%dumb}" \
    -a -z "${INSIDE_EMACS}" \
    -a "$-" != "*i*" \
    -a "${PARENT//lens/}" = "${PARENT}"; then
    ntmux
fi

unset PARENT
