# Run Adgaurd Home on Docker

AdGuard Home is a powerful network-wide software for blocking ads and tracking, acting as a DNS server that filters traffic before it reaches your devices. It provides an easy-to-use web interface for configuration, supports DNS-over-HTTPS, DNS-over-TLS, and DNSCrypt, and can be deployed on various platforms including Docker. With AdGuard Home, you can enhance privacy, security, and browsing speed for all devices on your network.

## Prerequisites

* Install Docker and Docker compose
* Disable resolver on local host

## Docker Compose File

```yml
version: "3"
services:
  adguardhome:
    image: adguard/adguardhome
    container_name: adguardhome
    ports:
      # Plain DNS
      - '53:53/tcp'
      - '53:53/udp'
      # AdGuard Home Admin Panel as well as DNS-over-HTTPS
      - '80:80/tcp'
      - '443:443/tcp'
      - '443:443/udp'
      - '3000:3000/tcp'
      # DNS-over-TLS
      - '853:853/tcp'
      # DNS-over-QUIC
      - '784:784/udp'
      - '853:853/udp'
      - '8853:8853/udp'
      # DNSCrypt
      - '5443:5443/tcp'
      - '5443:5443/udp'
    volumes:
      - ./workdir:/opt/adguardhome/work
      - ./confdir:/opt/adguardhome/conf
    restart: unless-stopped
```

## How to Deploy

1. Create Directory for Adgaurd Config and Compose Files

```bash
mkdir /docker/adgaurd
cd /docker/adgaurd
```

2. Create Docker Compose File

```bash
nano docker-compose.ymal
```

3. Run Docker Compose

```bash
docker-compose up -d
```

## How to Update

To update the currently running docker image.

1. Navigate to the adgaurd directory

```bash
cd /docker/adgaurd
```

2. Pull the latest version of AdGuard

```bash
docker compose pull
```

3. Run Docker compose to move to the latest image of AdGuard Home installation. This command will detect that a new image is available and automatically restart any affected containers to the new release.

```bash
docker compose up -d
```

## Port 53 on Host Machine

For Adgaurd to serve up DNS responses it needs to bind to Port 53. On the Docker host machine Port 53 may be in uses by other system services, that's why you can not bind 53 to host.

To find what is using port 53 ```sudo lsof -i -P -n | grep LISTEN```

### disable Systemd-resolved

If the systemd-resolved is what is listening to port 53. To solve that you need to disable it. Run the following to disable:

```bash
systemctl disable systemd-resolved.service
systemctl stop systemd-resolved
```

Now you have port 53 open, but no dns configured for your host. To fix that, you need to edit ```'/etc/resolv.conf'``` and add the dns address.

```bash
nameserver 1.1.1.1
```

Once the docker container gets running, you can change the dns server of your host to localhost. By change again ```'/etc/resolv.conf'``` by changing the name server to local host.

```bash
nameserver 127.0.0.1
```
