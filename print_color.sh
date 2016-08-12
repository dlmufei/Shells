#!/bin/bash

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
