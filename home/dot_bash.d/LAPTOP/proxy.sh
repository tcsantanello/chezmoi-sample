
__no_proxy=(
  # proxy blacklist
)

join() {
  local sep=$1; shift
  local f=$1; shift
  printf "%s" $f ${@/#/$sep}
}

export HTTP_PROXY=## Proxy
export HTTPS_PROXY=${HTTP_PROXY}
export http_proxy=${HTTP_PROXY}
export https_proxy=${HTTP_PROXY}
export NO_PROXY="$( join "," ${__no_proxy[@]} )"
export no_proxy="${NO_PROXY}"

unset join __no_proxy
