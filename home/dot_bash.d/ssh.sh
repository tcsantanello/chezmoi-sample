#!/bin/bash

__sshpass=$( which sshpass )
if test -n "${__sshpass}"; then
    __ssh=$( which ssh ) 
    __sftp=$( which sftp ) 
    __rsync=$( which rsync ) 

    # $( which ssh ) -h 2>&1 | sed '/-[^- \t]*/!d;s/\[-/\n-/g;s/ .*\]$/:/g;s/\]//g'
    ssh() {
        local OPTIND=0
        local host=""
        
        # Don't care about the arguments, just want to advance past all of them to get to the hostname
        while getopts "46AaCfGgKkMNnqsTtVvXxYyB:b:c:D:E:e:F:I:i:J:L:l:m:O:o:p:Q:R:S:W:w:" foo; do :; done

        eval host="\${$(( $OPTIND ))}"

        PASSWORD="$( awk -v host="$host" \
            '/#Password/ && inhost { 
             print $2
          }

          /Host / { 
             inhost=index( $0, host ); 
          }' $HOME/.ssh/config
        )"

        kinit -R || kinit -r $(( 86400 * 7 ))

        if test -n "${PASSWORD}"; then
            SSHPASS="${PASSWORD}" ${__sshpass} -e ssh "$@"
        else
            ${__ssh} "$@"
        fi
        
        unset PASSWORD
        
        return $?
    }

    sftp() {
        local OPTIND=0
        local host=""
        # Don't care about the arguments, just want to advance past all of them to get to the hostname
        while getopts "46aCfpqrvB:b:c:D:F:i:l:o:P:R:S:s:" foo; do :; done

        eval host="\${${OPTIND}//*@}"

        PASSWORD="$( awk -v host="$host" \
            '/#Password/ && inhost { 
             print $2
          }

          /Host / { 
             inhost=index( $0, host ); 
          }' $HOME/.ssh/config
        )"
        
        kinit -R || kinit -r $(( 86400 * 7 ))

        if test -n "${PASSWORD}"; then
            SSHPASS="${PASSWORD}" ${__sshpass} -e sftp "$@"
        else
            ${__sftp} "$@"
        fi
        
        unset PASSWORD
        
        return $?
    }

    function rsync() {
        local src=""
        local dest=""
        local host=""
        local sarg=""
        local darg=""
        
        eval sarg=\${$(($#-1))}
        eval darg=\${$$#}
        
        src=${sarg%%:/*}
        dest=${darg%%:/*}
        
        if test "${sarg}" != "${src}"; then
            host=${src//*@}
        elif test "${darg}" != "${dest}"; then
            host=${dest//*@}
        else
            $( which rsync ) "$@"
            return $?
        fi
        
        PASSWORD="$( awk -v host="$host" \
            '/#Password/ && inhost { 
             print $2
          }

          /Host / { 
             inhost=index( $0, host ); 
          }' $HOME/.ssh/config
        )"
        
        if test -n "${PASSWORD}"; then
            SSHPASS="${PASSWORD}" ${__rsync} -e rsync "$@"
        else
       ${__rsync} "$@"
        fi
        
        unset PASSWORD
        
        return $?
    }
fi
