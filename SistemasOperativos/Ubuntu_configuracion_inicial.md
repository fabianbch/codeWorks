# Rutina de configuración integral de un servidor Ubuntu 24.04
**by [gWorks Cloud Solutions](https://www.gworks-ec.com)**

**PRE-REQUISITOS MANDATORIOS.**

<br>

1. Instalación de comandos básicos:

<br>

`$ sudo apt install iputils-ping`

`$ sudo apt install net-tools`

`$ sudo apt install bash-completion`

`$ source ~/.bashrc`

<br>

2. Configuración del nombre del servidor:

<br>

`$ hostname`

`$ sudo hostnamectl set-hostname srvmaster.so2.local`

<br>

3. Edita el archivo hosts para relacionar con su hostname FQDN:

<br>

`$ sudo nano /etc/hosts`

`192.168.5.10    master.so2.local`

`192.168.5.10    mail.so2.local`

<br>

4. Muestra su zona horaria actual, por ejemplo Ecuador (GMT -5):

<br>

`$ sudo timedatectl`

`$ sudo timedatectl | grep Time`

<br>

5. Establece la zona horaria deseada, por ejemplo, "America/Guayaquil":

<br>

`$ sudo timedatectl set-timezone "America/Guayaquil"`

<br>

6. Aplicar los cambios, reiniciando el servidor:

<br>

`$ sudo reboot now`

<br>

**MANIPULACIÓN DE INTERFACES DE RED EN LINUX**

<br>

1. Edición del archivo de configuración de interfaz de red:

<br>

`$ sudo nano /etc/netplan/50-cloud-init.yaml`

<br>

2. Configuración de interfaz LAN:

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

3. Aplicar los cambios:

<br>

`$ sudo netplan apply`

<br>

4. Configuración de interfaz WAN:

<br>

`$ sudo nano /etc/netplan/02-netcfg.yaml`

<br>

5. Configuración del archivo:

<br>

`network:`
`  ethernets:`
`    ens37:`
`      dhcp4: yes`
`  version: 2`
`  renderer: networkd`

<br>
  
6. Aplicar los cambios:

<br>

`$ sudo netplan apply`

<br>