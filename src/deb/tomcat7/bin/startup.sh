#!/usr/bin/env bash

export CATALINA_BASE="$( dirname "${BASH_SOURCE[0]}" )"/..
/usr/share/tomcat7/bin/startup.sh
echo "Tomcat started"
