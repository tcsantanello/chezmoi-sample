#!/bin/awk -f

function init( ) {
    contents = "";
    dateStr = "";
    file = "";
    decode = 0;
    base64 = 0;
}

function makeFileName( str ) {
    ind = index( str, "." );
    file = substr( str, 1, ind - 1 ) "-" dateStr substr( str, ind );
}

BEGIN {
    init( );
}

/^Date:/ { 
    cmd="date +'%Y%m%d-%H%M%S' -d '" substr( $0, 7 ) "'";

    cmd | getline
   
    dateStr = $0;    

    close( cmd );
}

decode == 0 && /Content-Type: application\/octet-stream;/ {
    base64 = 1;
    makeFileName( substr( $3, 7, length( $3 ) - 7 ) );
}

/^begin 644/ && base64 == 0 {
    decode = 1;
    makeFileName( $3 );
}

base64 == 1 && /^$/ {
    decode = 1;
}

decode == 1 {
    contents = contents "\n" $0;
}

( /^end/ || ( base64 == 1 && /^$/ && length( contents ) > 2 ) ) && decode == 1 {
    if ( base64 == 1 ) {
        decode = "base64 -i -d > output/" file; 
    } else {
        decode = "uudecode -o output/" file; 
    }

    print decode;
    
    print contents | decode;

    close( decode );

    init( );
}