# -*- Mode: sh -*-

if test -n "$( which od 2>/dev/null )"; then
  random() { 
    if test -n "$1"; then
      od -tu8 < /dev/urandom | \
        awk -v left=$1 '{
          num  = $2 "" $3; 
          num  = substr( num, 0, left );
          left = left - length( num );
          printf( "%s", num );
          if ( left <= 0 ) {
             exit( 0 );
          }
       }' 
    fi
  }
fi
