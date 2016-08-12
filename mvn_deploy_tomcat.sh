#!/bin/bash

# -----------------------------------------------------------------------------
# Deploy Script
# -----------------------------------------------------------------------------

source /data/tool/print_color.sh
#export JAVA_HOME=/usr/local/services/jdk1.7.0_45-1/jdk1.7.0_45/
#export PATH=$JAVA_HOME/bin:$PATH
#export MAVEN_HOME=/usr/local/services/apache_maven
#export PATH=$MAVEN_HOME/bin:$PATH

PROJECT_NAME="$1"
TOMCAT_NAME="$2"
PROJECT_DEPLOY_LOCATION="/usr/local/services/$TOMCAT_NAME/webapps/"

echo "Compiling $PROJECT_NAME..." | printColor red bold
pwd
cd $PROJECT_NAME
mvn clean install -q -e
echo "Completed And Continue..." | printColor green bold

echo "Removing old $PROJECT_NAME tomcat folder" | printColor red bold
rm -rf $PROJECT_DEPLOY_LOCATION$PROJECT_NAME
echo "Completed And Continue..." | printColor green bold

echo "Copying new $PROJECT_NAME target to tomcat folder" | printColor red bold
cp target/$PROJECT_NAME -r $PROJECT_DEPLOY_LOCATION
echo "Completed And Continue..." | printColor green bold

/data/project/onekeydeploy/tool/tomcat_shell.sh $TOMCAT_NAME restart
