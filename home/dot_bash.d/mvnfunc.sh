
function testresults() { awk '/ExecutionEventLogger/ && /Building/ { name=$7 } /Results ?:/,/Tests run:/ { if ( index( $0, "Tests run" ) > 0 ) { l=$0; sub( /.*- /, "", l ); arr[name]=l } } END { for ( k in arr ) { printf( "%-30s %s\n",k,arr[k]) } }' "${1}"; }
function testtimes() {
  diff --side-by-side --width=260 \
      <(sed -n '/Logline/p;/Reactor Summary/,/Final/ { s,.* - ,,; p }' "${1}") \
      <(sed -n '/Logline/p;/Reactor Summary/,/Final/ { s,.* - ,,; p }' "${2}") | \
    sed -n '1,/silo/{s, \.\+ \(SUCCESS\|FAILURE\) \[ *\([^]]*\)\],\,\2,g;p}' | \
    sed 's,[ \t][ \t]\+[^,]\+,,g'
}

function diff_testresults {
  diff --side-by-side --width=260 \
     <( testresults "$1" ) \
     <( testresults "$2" ) 
}

#function testresults() { awk '/ExecutionEventLogger/ && /Building/ { name=$7 } /Results :/,/SurefirePlugin/ { if ( index( $0, "Tests run" ) > 0 ) { arr[name]=$0 } } END { for ( k in arr ) { printf( "%-30s %s\n",k,arr[k]) } }' "${1}"; }

