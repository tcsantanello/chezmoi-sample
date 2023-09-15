# -*- Mode: sh -*-

#alias update_kubectl='python <( curl https://raw.githubusercontent.com/ahmetb/kubectl-aliases/master/generate_aliases.py ) | tee ~/.bash.d/kubectl.sh'
alias which='which 2>/dev/null'
alias -- -='cd -'
alias ..='cd ..'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias fn='find . -name '
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias kubesplit="yq e -s '.kind + \"-\" + .metadata.name' '.items[]'"

case $( uname ) in
  Darwin)
    alias ls='ls --color=always -pC'
    ;;
  *)
    alias ls='ls --color=tty -pCN'
    ;;
esac

#test -x "$( which kubecolor )" && alias kubectl='kubecolor'
test -n "$( which less )" && alias more='less'

if test -n "$( which gdb )"; then
  test -n "$( which emacs )" && alias gdbtool='$EDITOR -e "(gdb \"gdb --annotate=3 '"'"'\!*'"'"'\"\)"'
  alias bt='gdb --batch --quiet -ex "thread apply all bt full" -ex "quit" $1 $2 | cat -'
fi

#alias diff='diff -W $( tput cols ) --side-by-side '
alias nohup='$(which nohup) &>/dev/null'
test -n "$( which xterm )" && alias xterm="xterm -bg black -fg white -e '${SHELL} -l'"

if test -n "$( which rsync )"; then
  alias pcp='$( which time ) rsync --progress -aXAHhc '
  alias pmv='$( which time ) rsync --progress -aXAHhc --remove-source-files '
fi

alias oops='sudo !!'

if test -n "$( which rlwrap 2>/dev/null )"; then
  if test -f /usr/share/java/bsh.jar; then
    alias bsh="$( which rlwrap ) java -cp /usr/share/java/bsh.jar bsh.Interpreter"
  fi
fi

if test -n "$( which dosbox 2>/dev/null )" -a -f ~/.dosbox/config; then
  alias dosbox='$(which dosbox) -conf $HOME/.dosbox/config'
fi


test -n "$( which wget   )" && alias wgetm='wget -mkEpnp'
test -n "$( which rdfind )" && alias dedup='rdfind -makehardlinks true'

alias fixperms='_fp() { find "$@" \( -type d -a -exec chmod 755 {} \; \) -o \( -type f -a \( -exec sh -c "file -b {} | grep -i exec >&/dev/null && chmod 755 {}" \; -o -exec chmod 644 {} \; \) \); }; _fp "$@"'
