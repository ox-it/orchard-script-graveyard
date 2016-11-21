#!/bin/bash

# Script to run after Oracle Java 7 package installation (ie. in JSS policies
# for both installs and updates) to appropriately disable or leave enabled the
# Java 7 web plugin. The convenience symlink to the Java 7 JRE,
# /Library/Java/JavaVirtualMachines/1.7.x.jre, is also created/updated each
# time. 

# Copyright (C) 2013 Oxford University
#    Robin Miller <robin.miller(at)it.ox.ac.uk>
#
# This program is free software; you can redistribute 
# it and/or modify it under the terms of the GNU 
# General Public License version 3 as published by 
# the Free Software Foundation.
#
# $HeadURL: https://svn.oucs.ox.ac.uk/groups/nsms/src/n/nsms-mmp-scripts/trunk/Java_7_Post_Install.sh $
# $LastChangedRevision: 18067 $
# $LastChangedDate: 2015-09-07 13:46:31 +0100 (Mon, 07 Sep 2015) $
# $LastChangedBy: oucs0089 $


PLUGINS_DIR='/Library/Internet Plug-Ins'
DISABLED_PLUGINS_DIR="${PLUGINS_DIR}/disabled"
JAVA_PLUGIN='JavaAppletPlugin.plugin'
BREADCRUMB_PATH='/etc/nsms'
BREADCRUMB='java_master_switch_web_java_enabled'
JRE_7_LINK_PATH='/Library/Java/JavaVirtualMachines'
JRE_7_LINK_FILE='1.7.x.jre'


# Check that we're running on 10.7 or higher:
OS_VERSION=$(/usr/bin/sw_vers -productVersion | /usr/bin/awk -F'.' '{ print $2 }')
if [ $OS_VERSION -lt 7 ]; then
    echo "This script is for Mac OS X 10.7 or higher only."
    exit 1
fi

# Check for breadcrumb and create appropriate symlink in
# /Library/Java/JavaVirtualMachines/. Move plugin to disabled folder if
# breadcrumb not present.

 if [ -e "${BREADCRUMB_PATH}/${BREADCRUMB}" ]; then

     echo "Leaving plugin in active location."

     # just create Java 7 JRE symlink, and leave plugin in active location
     [ -d "$JRE_7_LINK_PATH" ] || /bin/mkdir -p "$JRE_7_LINK_PATH"
     /bin/ln -sf "${PLUGINS_DIR}/${JAVA_PLUGIN}" "${JRE_7_LINK_PATH}/${JRE_7_LINK_FILE}"

 else

     echo "Moving plugin to disabled location."

     [ -e  "${DISABLED_PLUGINS_DIR}" ] || /bin/mkdir "${DISABLED_PLUGINS_DIR}" 

     [ -e "${DISABLED_PLUGINS_DIR}/${JAVA_PLUGIN}" ] && /bin/rm -rf "${DISABLED_PLUGINS_DIR}/${JAVA_PLUGIN}"
     /bin/mv "${PLUGINS_DIR}/${JAVA_PLUGIN}" "${DISABLED_PLUGINS_DIR}/${JAVA_PLUGIN}"


     # create Java 7 JRE symlink
     [ -d "$JRE_7_LINK_PATH" ] || /bin/mkdir -p "$JRE_7_LINK_PATH"
     /bin/ln -sf "${DISABLED_PLUGINS_DIR}/${JAVA_PLUGIN}" "${JRE_7_LINK_PATH}/${JRE_7_LINK_FILE}"

 fi



