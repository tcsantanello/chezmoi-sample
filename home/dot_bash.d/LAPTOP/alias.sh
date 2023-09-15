
alias bww='f(){ ( unset ${!http*} ${!HTTP*}; command bww "$@"; )}; f'

oclo() {
  local id=268a54a8-f165-4f09-ab9e-f84225a6d3d3
  echo $( bww get password ${id} ) | oc login -u $( bww get username ${id} )
}

oclogin() {
  local OKC=${KUBECONFIG:-~/.kube/config}
  local KUBECONFIG=${OKC}
  local KUBECONFIG_AUTO=${KUBECONFIG}-auto
  local ocp_user=$(bww get username 268a54a8-f165-4f09-ab9e-f84225a6d3d3)

  cp ${KUBECONFIG} ${KUBECONFIG_AUTO}

  ( export KUBECONFIG=${KUBECONFIG_AUTO};
    # Get list of OCP contexts with unique user logins
    kubectl config view -o json | jq -r '
        [ . as $root
          | $root | .clusters[]
          | select( ( .name | contains( "openshift" ) ) or
                    ( .name | contains( "ocp" ) ) ).name as $names
          | $root | .contexts[]
          | select( ( .context.cluster | contains( $names ) ) and
                    ( .context.user | contains("'${ocp_user}'") ) )
          | { "name": .name, "user": .context.user } ]
        | unique_by( .user )
        | .[] | "\( .name ) \( .user )"
    ' | while read context user; do
      chiclet=$HOME/.kube/cache/$( openssl sha1 <<< "${user}" )

      if test -f ${chiclet}; then
        if test $( date -r ${chiclet} +%s ) -gt $(( $( date +%s ) - 86400 )); then
          continue
        fi
      fi

      if kubectl --context ${context} auth can-i get nodes 2>&1 | grep Unauth >& /dev/null; then
        echo "${user}:"
        echo "  Performing login"
        kubectl config use-context ${context} >& /dev/null
        oclo >& /dev/null

        echo "  Copying new token"
        kubectl --kubeconfig ${OKC} config set-credentials ${user} --token="$(
          kubectl config view  --minify --raw -o jsonpath='{range .users[*]}{.user.token}{end}'
        )"
      fi

      touch ${chiclet}
    done
  )
}

oclogin >& /dev/null
