# Implementación de servidores DNS Bind9 en Ubuntu Server 24.04
**by [gWorks Cloud Solutions](https://www.gworks-ec.com)**

<br>

1. Instalación del servidor DNS Bind9:

<br>

```shell

$ sudo apt install bind9 bind9utils bind9-doc dnsutils

```

<br>

2. Edición del archivo de configuración de Bind9 para el dominio so2.local:

<br>

```shell

$ sudo nano /etc/bind/named.conf.local

```

<br>

3. Adición de la configuración para la zona maestra:

<br>

```shell

zone "so2.local" {
    type master;
    file "/etc/bind/db.so2.local";
};

```

<br>

```shell

zone "5.168.192.in-addr.arpa" {
    type master;
    file "/etc/bind/db.192.168.5";
};

```

<br>

4. Creación del archivo de zona maestra:

<br>

```shell

$ sudo cp /etc/bind/db.local /etc/bind/db.so2.local

$ sudo nano /etc/bind/db.so2.local

```

<br>

5. Contenido del archivo:

<br>

```shell

;
; BIND data file for local zone
;
$TTL    604800
@       IN      SOA     ns.so2.local. root.so2.local. (
                      2         ; Serial
                 604800         ; Refresh
                  86400         ; Retry
                2419200         ; Expire
                 604800 )       ; Negative Cache TTL
;
@       IN      NS      ns.so2.local.
ns      IN      A       192.168.5.10
master  IN      A       192.168.5.10
www     IN      A       192.168.5.10
mail    IN      A       192.168.5.10
ftp     IN      A       192.168.5.10

```

<br>

6. Creación del archivo de zona reversa:

<br>

```shell

$ sudo cp /etc/bind/db.127 /etc/bind/db.192.168.5

$ sudo nano /etc/bind/db.192.168.5

```

<br>

7. Contenido del archivo:

<br>

```shell

;
; BIND reverse data file for local 192.168.5. network
;
$TTL    604800
@       IN      SOA     ns.so2.local. root.so2.local. (
                      2         ; Serial
                 604800         ; Refresh
                  86400         ; Retry
                2419200         ; Expire
                 604800 )       ; Negative Cache TTL
;
@       IN      NS      ns.so2.local.
10      IN      PTR     ns.so2.local.
10      IN      PTR     master.so2.local.
10      IN      PTR     www.so2.local.
10      IN      PTR     mail.so2.local.
10      IN      PTR     ftp.so2.local.

```

<br>

8. Configuración de opciones del servidor DNS Bind9:

<br>

```shell

$ sudo nano /etc/bind/named.conf.options

```

<br>

9. Comente la línea como se indica:

<br>

```shell

options {
 listen-on port 53 { 127.0.0.1; };
 //listen-on-v6 port 53 { ::1; };
 ...

```

<br>

10. Modificación del archivo **/etc/default/named**:

<br>

```shell

$ sudo nano /etc/default/named

```

<br>

11. Configuración del parámetro **OPTIONS**:

<br>

```shell

OPTIONS="-4 -u bind"

```

<br>

12. Reinicio sel servidor DNS Bind9 para aplicar los cambios:

<br>

```shell

$ sudo systemctl restart bind9

$ sudo systemctl status bind9

```

<br>

13. Comprobación de la configuración del servidor DNS Bind 9:

<br>

```shell

$ nslookup www.so2.local

$ dig www.so2.local

```
