# Implementación de servidores DHCP en Ubuntu Server 24.04
**by [gWorks Cloud Solutions](https://www.gworks-ec.com)**

<br>

1. Instalación del servidor DHCP:

<br>

```shell

$ sudo apt install isc-dhcp-server

```

<br>

2. Edición del archivo de configuración del servidor DHCP:

<br>

```shell

$ sudo nano /etc/dhcp/dhcpd.conf

```

<br>

3. Configuración del archivo de parámetros:

<br>

- Parámetros globales:

<br>

```shell

default-lease-time 600;
max-lease-time 7200;
option domain-name "so2.local";
option domain-name-servers 192.168.5.10;
subnet 192.168.5.0 netmask 255.255.255.0 {
    range 192.168.5.50 192.168.5.100;
    option routers 192.168.5.10;
    option subnet-mask 255.255.255.0;
}

```

<br>

- Asignación estática de direcciones de red por MAC Address:

<br>

```shell

host windows-client {
    hardware ethernet 00:1A:2B:3C:4D:5E;
    fixed-address 192.168.5.20;
}

```

<br>

4. Asignación de la interfaz de red en la que el servidor DHCP debe escuchar las peticiones DHCPREQUEST:

<br>

```shell

$ sudo nano /etc/default/isc-dhcp-server

INTERFACESv4 = "ens33"

```

<br>

5. Ejecución automática del servidor DHCP:

<br>

```shell

$ sudo systemctl enable isc-dhcp-server

```

<br>

6. Reinicio del servicio DHCP para aplicar los cambios:

<br>

```shell

$ sudo systemctl restart isc-dhcp-server

```
