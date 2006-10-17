#!/bin/sh

echo
echo "Wrapper Build System"
echo "--------------------"

if [ "$WRAPPER_TOOLS" = "" ] ; then
    WRAPPER_TOOLS=tools/apache-ant-1.6.2
fi

# Make sure our own copy of Ant is used even if the user has defined their own.
ANT_HOME=$WRAPPER_TOOLS

chmod u+x $WRAPPER_TOOLS/bin/antRun
chmod u+x $WRAPPER_TOOLS/bin/ant

$WRAPPER_TOOLS/bin/ant -logger org.apache.tools.ant.NoBannerLogger -emacs -Dtools.dir=$WRAPPER_TOOLS -Dbits=32 $@ 
