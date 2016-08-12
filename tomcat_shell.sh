#!/bin/bash
## Filename: tomcat_shell

TOMCAT_CHAC=$1
TOMCAT_BIN="bin/startup.sh"
TOMCAT_HOME="/usr/local/services/${TOMCAT_CHAC}"
TOMCAT_LOG="${TOMCAT_HOME}/logs/catalina.out"

RETVAL=0

printColor() {
    case $1 in
        red)    nn=31;;
        green)  nn=32;;
        yellow) nn=33;;
        blue)   nn=34;;
        purple) nn=35;;
        cyan)   nn=36;;
    esac
    ff=""
    case $2 in
        bold)   ff=";1";;
        bright) ff=";2";;
        uscore) ff=";4";;
        blink)  ff=";5";;
        invert) ff=";6";;
    esac
    COLOR_BEGIN=$(echo -e -n "\033[${nn}${ff}m")
    COLOR_END=$(echo -e -n "\033[0m")
    while read LINE; do
        echo "${COLOR_BEGIN}${LINE}${COLOR_END}"
    done
}

checkRun() {
	PID=$(ps -ef | grep ${TOMCAT_CHAC} | grep "[Dd]java.util.logging.config.file=${TOMCAT_HOME}/conf/logging.properties" | awk '{print $2}')
	if [[ -n "${PID}" ]]; then
		RETVAL=0
		return $RETVAL
	else
		RETVAL=1
		return $RETVAL
	fi
}

sleepFun() {
	sleep 0.5
}

checkExist() {
	if [[ ! -d ${TOMCAT_HOME} ]]; then
        echo "${TOMCAT_CHAC}: ${TOMCAT_HOME} does not exist." | printColor red bold
        exit 0
    fi
}

checkLog() {
    answer=$1
    if [[ "${answer}" != "yes" ]]; then
        read -p "-- See Catalina.out log to check $2 status?[yes]" answer
    fi
    case $answer in
        Y|y|YES|yes|Yes|"")
            tail -fn 500 ${TOMCAT_LOG}
        ;;
        *)
        ;;
    esac
}

start() {
    checkRun
    if [[ ${RETVAL} -ne 0 ]]; then
        echo "Starting ${TOMCAT_CHAC}..." | printColor green bold
        $TOMCAT_HOME/$TOMCAT_BIN > /dev/null 2>&1
        sleepFun
    else
        echo "${TOMCAT_CHAC} is started." | printColor red bold
    fi
}

stop() {
    checkRun
    if [[ ${RETVAL} -eq 0 ]]; then
        echo "Shutting down ${TOMCAT_CHAC}..." | printColor red bold
        kill -9 ${PID} > /dev/null 2>&1
        sleepFun
    else
        echo "${TOMCAT_CHAC} is stopped." | printColor red bold
    fi
}

status() {
    checkRun
    if [[ $RETVAL -eq 0 ]]; then
        echo "${TOMCAT_CHAC} pid is ${PID}." | printColor red bold
    else
        echo "${TOMCAT_CHAC} is not running." | printColor red bold
    fi
}

restart() {
    stop
    start
}

log() {
    status
    checkLog yes
}

case $2 in
    start)
        checkExist
        start && exit 0
    ;;  
    stop)
        checkExist
        stop ||exit 0
    ;;  
    status)
        checkExist
        status
    ;;  
    restart)
        checkExist
        restart
    ;;
    log)
        checkExist
        log
    ;;
    *)  
        echo $"Usage: $0 tomcat_server {start|stop|status|log}"
        exit 2
    ;;  
esac
