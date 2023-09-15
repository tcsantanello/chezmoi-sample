
function envsw( ) {
    CWD=${PWD}
    OTHER=${CWD/\/build\//\/}
    
    if test "${OTHER}" = "${CWD}"; then
        OBASE=$( while test ! -d build; do cd ..; echo $PWD; done | tail -n 1 )
        
        OTHER=${OBASE}/build/${CWD:${#OBASE}+1}
    fi
    
    cd "${OTHER}"
}
