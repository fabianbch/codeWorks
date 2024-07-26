# Rutina de configuración inicial de un servidor Ubuntu 24.04
**by [gWorks Cloud Solutions](https://www.gworks-ec.com)**

<br>

**PRE-REQUISITOS MANDATORIOS.**

<br>

1. Instalación de comandos básicos:

<br>

```

$ sudo apt install iputils-ping
$ sudo apt install net-tools
$ sudo apt install bash-completion
$ source ~/.bashrc

```

<br>

2. Configuración del nombre del servidor:

<br>

`$ hostname`

`$ sudo hostnamectl set-hostname srvmaster.so2.local`

<br>

3. Edición del archivo **hosts** para relacionar con su hostname FQDN:

<br>

`$ sudo nano /etc/hosts`

`192.168.5.10    master.so2.local`

`192.168.5.10    mail.so2.local`

<br>

4. Verificación de su zona horaria actual, por ejemplo Ecuador (GMT -5):

<br>

`$ sudo timedatectl`

`$ sudo timedatectl | grep Time`

<br>

5. Establecimiento de la zona horaria deseada, por ejemplo "America/Guayaquil":

<br>

`$ sudo timedatectl set-timezone "America/Guayaquil"`

<br>

6. Aplica los cambios, y reinicio del sistema:

<br>

`$ sudo reboot now`

<br>

**MANIPULACIÓN DE INTERFACES DE RED EN LINUX**

<br>

1. Edición del archivo de configuración de interfaz de red:

<br>

`$ sudo nano /etc/netplan/50-cloud-init.yaml`

<br>

2. Configuración de la interfaz LAN:

<br>

`network:`

`  ethernets:`

`    ens33:`

`      dhcp4: no`

`      addresses: [192.168.5.10/24]`

`      routes:`

`	  - to: default`

`        via: IP_INTERNET_GATEWAY`

`      nameservers:`

`        addresses: [192.168.5.10]`

`		search: [so2.local]`

`  version: 2`

`  renderer: networkd`

<br>

3. Aplica los cambios en las interfaces de red:

<br>

`$ sudo netplan apply`

<br>

4. Configuración de la interfaz WAN:

<br>

`$ sudo nano /etc/netplan/02-netcfg.yaml`

<br>

`network:`

`  ethernets:`

`    ens37:`

`      dhcp4: yes`

`  version: 2`

`  renderer: networkd`

<br>
  
5. Aplica los cambios en las interfaces de red:

<br>

`$ sudo netplan apply`

<br>
