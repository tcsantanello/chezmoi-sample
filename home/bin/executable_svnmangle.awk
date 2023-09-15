#!/usr/bin/gawk -f

function join( arg1, arg1Count, arg2 ) {
    retVal = "";
    for( i=0; i < arg1Count; ++i ){
        retVal = retVal arg1[ i ] arg2;
    }
    return retVal;
}

function trim( arg1 ) {
    gsub( /^[ \t]*/, "", arg1 );
    gsub( /[ \t]*$/, "", arg1 );
    return arg1;
}

function basename( arg1 ) {
    gsub( /.*\//, "", arg1 );
    return arg1;
}

function md5sum( arg1 ) {
    md5 = "md5sum";

    printf( "%s", arg1 ) |& md5;
    close( md5, "to" ); # close input
    md5 |& getline sum; # get md5sum
    close( md5 );       # close pipe

    return substr( sum, 1, 32 );
}

function transform( arg1 ) {
    gsub( /trunk\/tp3/,          "trunk",            arg1 );
    gsub( /tp3_transcend/,       "transcend",        arg1 );
    gsub( /tnsi\.com/,           "transcend.ath.cx", arg1 );
    gsub( /tp3/,                 "transcend",        arg1 );
    gsub( /TP3/,                 "transcend",        arg1 );
    return arg1;
}

function init( ){
#
    fileName= "";
    textLen = 0;
    propLen = 0;
#
    capture = 0;
    phase   = 0;
#
    newText = "";
    newLen  = 0;
#
#    
    split( "", lines, "" );      lineCount = 0;
    split( "", headers, "" );    headCount = 0;
    split( "", prop, "" );       propCount = 0;
#
}

function dump( ) {
    for( i = 0; i < headCount; ++i ) {
        if ( match( headers[ i ], "Text-content-length:[ \t]*" ) && newLen != 0 ) {
            printf( "%s%d\n", substr( headers[ i ], RSTART, RLENGTH ), newLen );
        } else if ( match( headers[ i ], "Text-content-md5:[ \t]*" ) && newLen != 0 ) {
            printf( "%s%s\n", substr( headers[ i ], RSTART, RLENGTH ), md5sum( newText ) );
        } else if ( match( headers[ i ], "Node-path:[ \t]*" ) && length( fileName ) ) {
            printf( "%s%s\n", substr( headers[ i ], RSTART, RLENGTH ), fileName );
        } else if ( match( headers[ i ], "Content-length:[ \t]*" ) && newLen != 0 ) {
            printf( "%s%d\n", substr( headers[ i ], RSTART, RLENGTH ), newLen + propLen );
        } else {
            printf( "%s\n", transform( headers[ i ] ) );
        }
    }

    for( i = 0; i < propCount; ++i ) {
        tmp = transform( prop[ i ] );

        if ( match( tmp, "[KV] " ) ) {
            tmp2 = "";
            for( j = i + 1; match( prop[ j ], "[KV] " ) == 0 && j < propCount - 1; ++j ) {
                tmp2 = tmp2 transform( prop[ j ] );
            }
            tmp2Len = length( tmp2 ) + ( j - i ) - 2;
            tmp = substr( tmp, 1, 1 ) " " tmp2Len;
        }
        if ( i == propCount - 1 ) {
            printf( "%s", tmp );
        } else {
            printf( "%s\n", tmp );
        }
    }
}

function finish( ) {
    if ( length( fileName ) ) {
        newText = join( lines, lineCount, "\n" );
        newText = transform( newText );
        newLen  = length( newText ) - 2;
        newText = substr( newText, 1, newLen );
        
        dump( );

        printf( "\n%s\n\n", newText );
    } else {
        dump( );
        if ( headCount || propCount ) {
            printf( "\n\n" );
        }
    }
    init( );
}

BEGIN {
    init();
}

END {
    finish();
}

function addLine( arg1, arg2 ) {
    if ( arg1 == "lines" ) {
        lines[ lineCount++ ] = arg2;
    } else if ( arg1 == "headers" ) {
        headers[ headCount++ ] = arg2;
    } else if ( arg1 == "prop" ) {
        prop[ propCount++ ] = arg2;
    }
    captured = 1;
}

{
    captured = 0;
    if ( match( $0, "[[:upper:]][[:alnum:]-]*: " ) == 1 ) {
        second = trim( substr( $0, index( $0, ":" ) + 1 ) );

        if ( $1 ~ /Text-content-length:/ ) {
            textLen = int( second );
        } else if ( $1 ~ /Prop-content-length:/ ) {
            propLen = int( second );
        } else if ( $1 ~ /Content-length:/ ) {
            addLine( "headers", $0 );
            phase = 1;
        } else if ( $1 ~ /Node-path:/ ) {
            finish();
            fileName = transform( second );
            capture = 1;
        } else if ( $1 ~ /Revision-number:/ ) {
            finish();
            capture = 1;
        }

        if ( capture && phase == 0 ) {
            addLine( "headers", $0 );
        }
    }

    if ( captured == 0 && phase > 0 ) {
        if ( phase > 1 ) {
            addLine( "lines", $0 );
        } else {
            if ( propLen ) {
                addLine( "prop", $0 );

                if ( $0 ~ /application\/octet-stream/ ) {
                    addLine( "prop", "" );
                    dump();
                    init();
                } else {
                    if ( index( $0, "PROPS-END" ) == 1  ) {
                        phase = 2;
                    } 
                }
            } else {
                if ( $0 ~ /^$/ ) {
                    phase = 2;
                }
            }
        }
    }

    if ( captured == 0 ) {
        print transform( $0 );
    }
}

