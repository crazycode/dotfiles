#!/bin/bash
export JAVA_OPTS="-server -Xmx1024m"
export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)
export PLAY_HOME=$HOME/opt/play-1.3.1
export PATH=$JAVA_HOME/bin:$PLAY_HOME:$PATH
