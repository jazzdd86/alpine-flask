# [Alpine OS](https://hub.docker.com/_/alpine/) running [Python Flask](http://flask.pocoo.org/)

This image is used to run flask applications. To start a container use
```
docker run --name flaskapp --restart=always -p 80:80 -v /path/to/app/:/app -d jazzdd/alpine-flask
```

`-v /path/to/app/:/app` - specifies the path to the folder containing a file named app.py, which should be your main application

`-p 80:80` - the image exposes port 80, in this example it is mapped to port 80 on the host

---
## Using more python or flask packages
This image comes with a basic set of additional packages. These are flask-wtf, flask-menu, flask-login, flask-mail, flask-babel and py-requests.
If you need any other python or flask packages, you can install them, using python pip.

```
docker exec YOUR_CONTAINER_ID/NAME /bin/bash -c "pip install package-name"
```

---
## Internals
The flask application is started using a UWSGI socket.

Nginx is used to map the socket to port 80 within the image. This image does not offer any SSL capability, please use a [nginx proxy](https://github.com/jwilder/nginx-proxy) for this.

UWSGI logs are saved to the /app directory, which means to your local file system or a linked container volume.

---
## Using this image to control docker with flask

This image can be used to create a privileged container, which can control your docker server. Therfore the docker socket must be mounted as volume within this container.
```
docker run --name flaskapp --restart=always \
    -p 80:80 \
    -v /path/to/app/:/app \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -d jazzdd/alpine-flask
```

Now you can use:

```
from subprocess import call
call(["docker", "run", "-p 80" ,"-v /path/to/app/:/app", "-d jazzdd/alpine-flask"])
```
to get another container running with the flask app.