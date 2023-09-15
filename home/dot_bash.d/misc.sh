
test -f /usr/local/bin/src-hilite-lesspipe.sh && export LESSOPEN="| /usr/local/bin/src-hilite-lesspipe.sh %s";
export LESS=" -R "

function upidof() { ps -u $USER -o pid,cmd | awk 'BEGIN{ PIDS="" }{ if ( $2 ~ /'$1'/ ) PIDS=PIDS" "$1; } END{ print PIDS }'; }
function lsop() { for proc in $@; do upidof $proc | xargs lsof -p; done; }
function bt() { gdb --batch --quiet -ex "thread apply all bt full" -ex "quit" $1 $2 | cat -; }
function diffsbs() { local ARGS=( $@ ); diff -W $( tput cols ) --side-by-side ${ARGS[${#ARGS[@]}-2]} ${ARGS[${#ARGS[@]}-1]}; }
