# Dockerized Apache2 Proxy

**FOR DEVELOPMENT PURPOSE ONLY**

This project contains docker files to build an image of a apache2 http proxy.

### Prerequisites

By default this runs apache server on port 443 (HTTPS) and 80 (HTTP). To run it in HTTPS on port 443, you need to have selfsigned key and certificate available in `./cert` directory in order to build the image. If you don't need to run it in HTTPS, remove virtualhost configuration for port 443 in the `apache-config.conf` accordingly.

### Steps to use 

1. Clone the repository
2. Change the configuration file `apache-config.conf` accordingly
3. Build the docker image
```
docker build -t apache2 .
```
4. Run the container
```
docker run -d -p 8080:80 -p 8081:443 apache2
```
5. Test the configuration on browser (trailing slash is required):

HTTPS configuration
```
https://localhost:8081/example/
```

HTTP configuration
```
http://localhost:8080/example/
```