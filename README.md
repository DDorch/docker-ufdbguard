# ufdbGuard docker image with UT1 blacklist integration

## Introduction

This image is an [ufdbGuard](https://www.urlfilterdb.com/) addition to [sameersbn/docker-squid](https://github.com/sameersbn/docker-squid) which synchronizes [the French UT1 blacklist](https://dsi.ut-capitole.fr/blacklists/) at container start up.

Access restriction to the proxy can be done by IP filtering and/or username/password access.

## Installation

### Requirements

You should have [docker installed on your server](https://docs.docker.com/get-docker/).

### Build the docker image

Download the repository:

```git clone git@github.com:DDorch/docker-ufdbguard.git```

And build the image:

```docker build --tag ufdbguard docker-ufdbguard```

### Run the container

The simple version:

```sudo docker run --name ufdbguard -d --publish 3128:3128 ufdbguard```

You can define authorized client IP addresses with the environment variable `LOCALNET`. Classical values for local networks are `192.168.0.0/16` or `10.0.0.0/8`. You can also enter several single IP adresses separated by spaces:

```sudo docker run --name ufdbguard -d --env LOCALNET="192.168.0.0/16 10.0.0.0/8" -v "$(pwd)"/volumes/squid/:/etc/squid -v "$(pwd)"/volumes/ufdbguard:/var/ufdbguard --publish 3128:3128 ufdbguard```

For data persistence of the configuration, you can use bind mounts:

```sudo docker run --name ufdbguard -d --env LOCALNET="192.168.0.0/16 10.0.0.0/8" -v "$(pwd)"/volumes/squid/:/etc/squid -v "$(pwd)"/volumes/ufdbguard:/var/ufdbguard --publish 3128:3128 ufdbguard```

## Password authentication

The default configuration accepts connexion from any IP address with correct authentication.

Users accounts are managed in `/etc/squid/users` file. You can register a new user with the following command:

```docker exec -it ufdbguard htpasswd -b /etc/squid/users username password```

And then restart the container:

```docker restart ufdbguard```

## Update blacklist

The blacklist is synchronized at each startup of the container. You can, for example, use a cron command to restart the container everyday at 2:30am:

```
crontab -e
```

And add:

```
30 2 * * * docker restart ufdbguard
```
