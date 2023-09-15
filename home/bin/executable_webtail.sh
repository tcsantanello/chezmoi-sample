#!/bin/bash

set -eou pipefail

URL=${1}

if test -z "${URL}"; then
    echo "Usage $0 <url to file>"
    exit 1
fi

while :; do
  read STATUS LENGTH <<<$( curl -s -I "${URL}" | sed '/HTTP\|Content-Length/!d;s,\(HTTP/1.1\|.*:\) \([0-9]*\).*,\2,;' | xargs echo )
  
  if test $(( $STATUS / 100 )) != 2; then
    >&2 echo "Error getting file status on ${URL}: $STATUS"
    exit 1 
  fi

  test ${last:-0} -gt $LENGTH && last=0

  if test ${last:-0} -ne $LENGTH; then
    curl -s --range ${last:-0}-$LENGTH "${URL}"
    last=${LENGTH}
  fi
  sleep 1
done
