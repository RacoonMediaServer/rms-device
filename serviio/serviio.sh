#!/bin/sh
### ====================================================================== ###
##                                                                          ##
##  Serviio start Script                                                    ##
##                                                                          ##
### ====================================================================== ###

echo "IP Address: $RMS_IP_ADDR"

DIRNAME=`dirname "$0"`
PROGNAME=`basename "$0"`

# OS specific support (must be 'true' or 'false').
cygwin=false;
darwin=false;
linux=false;
case "`uname`" in
    CYGWIN*)
        cygwin=true
        ;;

    Darwin*)
        darwin=true
        ;;
        
    Linux)
        linux=true
        ;;
esac

# For Cygwin, ensure paths are in UNIX format before anything is touched
if $cygwin ; then
    [ -n "$SERVIIO_HOME" ] &&
        SERVIIO_HOME=`cygpath --unix "$SERVIIO_HOME"`
    [ -n "$JAVA_HOME" ] &&
        JAVA_HOME=`cygpath --unix "$JAVA_HOME"`    
fi

# Setup SERVIIO_HOME
if [ "x$SERVIIO_HOME" = "x" ]; then
    # get the full path (without any relative bits)
    SERVIIO_HOME=`cd $DIRNAME/..; pwd`
fi
export SERVIIO_HOME

# Setup the JVM
if [ "x$JAVA" = "x" ]; then
    if [ "x$JAVA_HOME" != "x" ]; then
	JAVA="$JAVA_HOME/bin/java"
    else
	JAVA="java"
    fi
fi

# Setup the classpath
SERVIIO_CLASS_PATH="$SERVIIO_HOME/lib/*:$SERVIIO_HOME/config"

# Setup Serviio specific properties
JAVA_OPTS="-Djava.net.preferIPv4Stack=true -Djava.awt.headless=true -Dorg.restlet.engine.loggerFacadeClass=org.restlet.ext.slf4j.Slf4jLoggerFacade -Dderby.system.home=$SERVIIO_HOME/library -Dserviio.home=$SERVIIO_HOME -Dffmpeg.location=ffmpeg -Ddcraw.location=dcraw -Dserviio.boundAddr=$RMS_IP_ADDR"

# Check if we are using Java9
JAVA_VERSION=$("$JAVA" -version 2>&1 | awk -F '"' '/version/ {print $2}')
case "$JAVA_VERSION" in
    \1.8*) JAVA9_OPTS="" ;;
    *) JAVA9_OPTS="--add-modules jdk.unsupported" ;;
esac

# For Cygwin, switch paths to Windows format before running java
if $cygwin; then
    SERVIIO_HOME=`cygpath --path --windows "$SERVIIO_HOME"`
    JAVA_HOME=`cygpath --path --windows "$JAVA_HOME"`
    SERVIIO_CLASS_PATH=`cygpath --path --windows "$SERVIIO_CLASS_PATH"`
fi

# Execute the JVM in the foreground
exec "$JAVA" $JAVA9_OPTS -Xmx512M -Xms20M -XX:+UseG1GC -XX:GCTimeRatio=1 -XX:MinHeapFreeRatio=10 -XX:MaxHeapFreeRatio=20 $JAVA_OPTS -classpath "$SERVIIO_CLASS_PATH" org.serviio.MediaServer "$@"