
diffarray() {
    eval arr1=(\${$1[@]})
    eval arr2=(\${$2[@]})
    local rc=()

    for ((i1=0;i1<${#arr1[@]};++i1)); do
        found=0
        for ((i2=0;i2<${#arr2[@]};++i2)); do
            if test "${arr1[$i1]}" = "${arr2[$i2]}"; then
                found=1
            fi
        done
        if test $found -ne 1; then
            rc+=( "${arr1[$i1]}" )
        fi
    done
    echo ${rc[@]}
}

diffarray() {
    echo $( _diffarray $1 $2 ) $( _diffarray $2 $1 )
}
