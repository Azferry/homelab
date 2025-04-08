# How to set a static IP

netplan is a utility for configuring network interfaces in Ubuntu. It provides a simple and declarative way to define network configuration using YAML syntax. To easily configure network interfaces, IP addresses, routes, DNS settings, and more.

Netplan configuration files are located in the /etc/netplan directory and have a .yaml extension. Each configuration file represents a network interface or a set of network interfaces. The configuration files are processed by the netplan command, which generates the corresponding network configuration files in the /run/netplan directory. To apply the changes made in the netplan configuration files, you need to run the netplan apply command. This command applies the changes and updates the network configuration.


# Steps

Modify the yaml under the netplan path
```shell
cd /etc/netplan
```

Example Yaml
```Shell
network:
    version: 2
    renderer: networkd
    ethernets:
    eth0:
        addresses:
        - 192.168.110.176/24
        routes:
        - to: default
          via: 192.168.110.1
        nameservers:
            addresses: [192.168.110.4, 192.168.110.6]

```

Apply config

```shell
netplan apply
```
