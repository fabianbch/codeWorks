# Implementación de servidores de transferencia de archivos VSFTP en Ubuntu Server 24.04
**by [gWorks Cloud Solutions](https://www.gworks-ec.com)**

<br>

1. Instalación del servidor FTP (vsftpd):

<br>

`$ sudo apt install vsftpd`

<br>

2. Edición del archivo de configuración del servidor vsftpd:

<br>

`$ sudo nano /etc/vsftpd.conf`

<br>

- Asegúrese que las siguientes líneas estén configuradas:

<br>

`listen=NO`

`listen_ipv6=NO`

`anonymous_enable=NO`

`local_enable=YES`

`write_enable=YES`

`chroot_local_user=YES`

`user_sub_token=$USER`

`local_root=/home/$USER/ftp`

`pasv_min_port=10000`

`pasv_max_port=10100`

<br>

3. Asignación del directorio FTP y permisos necesarios para los recursos de los usuarios:

<br>

`$ sudo mkdir -p /home/usuario1/ftp/upload`

`$ sudo chmod 550 /home/usuario1/ftp`

`$ sudo chmod 750 /home/usuario1/ftp/upload`

`$ sudo chown -R usuario1:usuario1 /home/usuario1/ftp`

<br>

4. Ejecución automática del servidor FTP (vsftpd):

<br>

`$ sudo systemctl enable vsftpd`

<br>

5. Reinicio del servidor FTP (vsftpd) par aplicar los cambios:

<br>

`$ sudo systemctl restart vsftpd`