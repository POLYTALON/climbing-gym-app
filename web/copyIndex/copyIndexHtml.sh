#!/bin/bash
if [ ! -z "$1" ]
then
	case $1 in
	development)
		echo "copy Development Index.html to the web root folder!"
		cp web/development/index.html web/index.html
		;;
	productive)
        echo "copy Productive Index.html to the web root folder!"
        cp web/productive/index.html web/index.html
        ;;
	*)
		echo "Sorry, wrong argument, please try again"
		;;
    esac
else echo "Sorry, wrong argument, please try again"
fi
