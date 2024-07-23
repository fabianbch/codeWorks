# Implementación de servidores LAMP en Ubuntu Server 24.04
**by [gWorks Cloud Solutions](https://www.gworks-ec.com)**

<br>

1. Instalación de Apache Web Server:

<br>

`$ sudo apt update && sudo apt upgrade`

`$ sudo apt install apache2`

`$ sudo systemctl enable apache2`

`$ sudo systemctl start apache2`

<br>

2. Instalación del servidor MariaDB:

<br>

`$ sudo apt install mariadb-server`

`$ sudo systemctl enable mariadb`

`$ sudo systemctl start mariadb`

<br>

3. Aseguramiento de la instalación de MariaDB:

<br>

`$ sudo mysql_secure_installation`

<br>

4. Acceso a la consola de MySQL/MariaDB:

<br>

`$ sudo mysql -u root -p`

<br>

- Creación del usuario **admin_db**:

<br>

`CREATE USER 'admin_db'@'localhost' IDENTIFIED BY 'password';`

`CREATE USER 'admin_db'@'%' IDENTIFIED BY 'password';`

`GRANT ALL PRIVILEGES ON *.* TO 'admin_db'@'localhost';`

`GRANT ALL PRIVILEGES ON *.* TO 'admin_db'@'%';`

`FLUSH PRIVILEGES;`

`EXIT;`

<br>

6. Instalación de PHP:

<br>

`$ sudo apt install php libapache2-mod-php php-mysql php-fpm`

<br>

7. Edición del archivo de configuración de Apache:

<br>

`$ sudo nano /etc/apache2/mods-enabled/dir.conf`

<br>
