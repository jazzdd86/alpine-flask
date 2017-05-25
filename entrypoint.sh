#!/bin/bash
if [ ! -f /debug0 ]; then
	if [ -e requirements.txt ]; then
		pip3 install -r requirements.txt
	fi

	touch /debug0

	while getopts 'hdo:' flag; do
        	case "${flag}" in
                	h)
                        	echo "options:"
	                        echo "-h        show brief help"
        	                echo "-d        debug mode, no nginx or uwsgi, direct start with 'python app.py'"
                	        echo "-o gid    installs docker into the container, gid should be the docker group id of your docker server"
                        	exit 0
	                        ;;
        	        d)
				touch /debug1
                        	;;
	                o)
				apk add --no-cache docker shadow
				groupmod -g ${OPTARG} docker
				gpasswd -a nginx docker
        	                ;;
                	*)
                        	break
	                        ;;
        	esac
	done
fi

if [ -e /debug1 ]; then
	echo "Running app in debug mode!"
	python3 app.py
else
	echo "Running app in production mode!"
	openssl genrsa -out /etc/nginx/server.key 2048
	openssl req -new -x509 -key /etc/nginx/server.key -out /etc/nginx/server.crt -days 3650 -subj /CN=localhost
	nginx && uwsgi --ini /app.ini
fi
