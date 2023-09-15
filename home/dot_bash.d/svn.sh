# -*- Mode: sh -*-

if test -x "$( which svn )"; then
  svn() {
    local cmd=$1; shift

    # Expand aliases
    case "${cmd}" in
      "checkout"|"co") cmd="checkout"; ;;
      "diff"|"di") cmd="diff"; ;;
      "blame"|"praise"|"annotate"|"ann") cmd="blame"; ;;
      "tag") ;;
      "rtag") ;;
      "add") ;;
      "cat") ;;
      "changelist"|"cl") cmd="changelist"; ;;
      "cleanup") ;;
      "commit"|"ci") cmd="commit"; ;;
      "copy"|"cp") cmd="copy"; ;;
      "delete"|"del"|"remove"|"rm") cmd="remove"; ;;
      "export") ;;
      "import") ;;
      "info") ;;
      "list"|"ls") cmd="list"; ;;
      "lock") ;;
      "merge") ;;
      "mergeinfo") ;;
      "mkdir") ;;
      "move"|"mv"|"rename"|"ren") cmd="move"; ;;
      "patch") ;;
      "propdel"|"pdel"|"pd") cmd="propdel"; ;;
      "propedit"|"pedit"|"pe") cmd="propedit"; ;;
      "propget"|"pget"|"pg") cmd="propget"; ;;
      "proplist"|"plist"|"pl") cmd="proplist"; ;;
      "propset"|"pset"|"ps") cmd="propset"; ;;
      "relocate") ;;
      "resolve") ;;
      "resolved") ;;
      "revert") ;;
      "status"|"stat"|"st") cmd="status"; ;;
      "switch"|"sw") cmd="switch"; ;;
      "unlock") ;;
      "update"|"up") cmd="update"; ;;
      "upgrade") ;;
      *) ;;
    esac

    if test -n "$( which svn-${cmd} )"; then
      svn-${cmd} "$@" 
    else
      $( which svn ) "${cmd}" "${@}"
    fi

    return $rc
  }
fi
