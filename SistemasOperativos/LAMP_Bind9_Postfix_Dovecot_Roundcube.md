# Implementación de servidores de e-mail en Ubuntu Server 24.04
**by [gWorks Cloud Solutions](https://www.gworks-ec.com)**

Los servidores de correo electrónico o e-mail Servers son sistemas informáticos que permiten a los usuarios enviar, recibir y gestionar correos electrónicos.

Constituyen la base de la comunicación electrónica moderna, facilitando la comunicación entre personas, empresas y organizaciones:

- Administración de cuentas de usuarios.
Gestionan cuentas de usuario, permitiendo a cada usuario tener una dirección de correo electrónico única.

- Envío de mensajes.
Son responsables de enviar mensajes de correo electrónico a su destino, garantizando la entrega del mensaje a su destinatario.

- Almacenamiento de mensajes.
Almacenan todos los mensajes recibidos por los usuarios, incluso si el usuario no está en línea (correo diferido).

<br>

![](https://www.gworks-ec.com/nia/uploads/2024/07/Postfix_implementacion-e1721677764145.png)

<br>

1. Actualizar el sistema:

`$ sudo apt update && sudo apt upgrade`

<br>

**PRE-REQUISITOS MANDATORIOS.**

<br>

2. Configurar el hostname:

`$ sudo hostnamectl set-hostname master.so2.local`

`$ echo "192.168.5.10 master.so2.local mail.so2.local" | sudo tee -a /etc/hosts`

<br>

3. Configurar zona horaria:

`$ sudo timedatectl`

<br>

4. Eliminar configuraciones previas:

`$ sudo apt remove --purge postfix dovecot-core dovecot-imapd dovecot-pop3d roundcube roundcube-core roundcube-mysql`

`$ sudo apt autoremove`

`$ sudo apt autoclean`

`$ sudo rm -rf /etc/postfix /etc/dovecot`

<br>

**SERVIDOR E-MAIL POSTFIX.**

<br>

5. Instalar Postfix MTA:

`$ sudo apt install postfix`

`OPCIÓN 2: Internet Site.`

- Digite su `System mail name: so2.local`

<br>

`$ sudo nano /etc/postfix/main.cf`

`myhostname = master.so2.local`

`alias_maps = hash:/etc/aliases`

`alias_database = hash:/etc/aliases`

`myorigin = /etc/mailname`

`mydestination = $myhostname, so2.local, master.so2.local, localhost.so2.local, localhost`

`relayhost =`

`mynetworks = 127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128 192.168.5.0/24`

`...`

`inet_interfaces = all`

`inet_protocols = all`

- Agregar al final del archivo:

`home_mailbox = Maildir/`

`mailbox_command =`

<br>

`$ sudo systemctl restart postfix`

`$ sudo systemctl enable postfix`

`$ sudo apt install bsd-mailx`

<br>

- Mensaje enviado desde usuario1 al usuario2:

`$ mail usuario2`

`Cc: usuario1@so2.local`

`Subject: Asunto del correo de prueba.`

`¡Esto es una pruba!`

<br>

`$ mail`

`"/var/mail/usuario1": 1 message 1 new`

`N   1 Usuario 1        Sun Jul 21 10:50  14/478   Prueba`

`?`

<br>

6. Instalar Dovecot POP3, MDA:

`$ sudo apt install dovecot-pop3d dovecot-imapd`

`$ sudo nano /etc/dovecot/conf.d/10-auth.conf`

`disable_plaintext_auth = no`

<br>

`$ sudo nano /etc/dovecot/conf.d/10-mail.conf`

`mail_location = maildir:~/Maildir`

`#mail_location = mbox:~/mail:INBOX=/var/mail/%u`

<br>

`$ sudo systemctl restart dovecot`

`$ sudo systemctl enable dovecot`

<br>

**SERVIDOR DNS BIND9.**

<br>

7. Configuración Bind9:

`$ sudo nano /etc/bind/db.so2.local`

`mail    IN      A       192.168.5.10`

`@       IN      MX  10  mail.so2.local.`

<br>

`$ sudo nano /etc/bind/db.192.168.5`

`10      IN      PTR     mail.so2.local.`

<br>

`$ sudo resolvectl flush-caches`

`$ sudo systemctl restart bind9`

`$ dig -t MX so2.local`

`$ dig -t MX mail.so2.local`

<br>

**CLIENTE WEBMAIL ROUNDCUBE.**

<br>

8. Instalar Roundcube Webmail Client:

<br>

`$ sudo apt install roundcube`

- En la opción `dbconfig-common: yes`

- Proporcione una contraseña del usuario "roundcube"!!!

<br>

`$ sudo nano /etc/roundcube/config.inc.php`

`$config['default_host'] = 'mail.so2.local';`

`$config['imap_host'] = ["mail.so2.local:143"];`

`$config['smtp_host'] = 'mail.so2.local:25';`

`$config['smtp_user'] = '';`

`#Agregue las siguientes líneas al final para habilitar el debug de Roundcube.`

`$config['debug_level'] = 1;`

`$config['smtp_debug'] = true;`

<br>

9. Eventos de errores del servidor Postfix se almacenan en el directorio /var/log/roundcube:

`$ cd /var/log/roundcube`

`$ sudo cat errors.log`

`$ sudo cat smtp.log`

<br>

**AFINAMIENTO DE APACHE WEB SERVER.**

<br>

10. Configuración de Apache2:

`$ cd /etc/apache2/sites-available/`

`$ sudo cp 000-default.conf roundcube.conf`

`$ sudo nano roundcube.conf`

`ServerName mail.so2.local`

`...`

- Agregue las siguientes líneas al final del archivo:

`<Directory /var/lib/roundcube>`

`  Require all granted`

`</Directory>`

<br>

`$ cd /etc/apache2/sites-enabled/`

`$ sudo a2ensite roundcube.conf`

`$ sudo systemctl reload apache2`

`$ sudo systemctl restart apache2 postfix dovecot`

<br>

**PARAMETRIZACIÓN DE FIREWALL UFW.**

<br>

11. Configurar las reglas de filtrado en UFW:

<br>

`$ sudo ufw allow 22`

`$ sudo ufw allow 80`

`$ sudo ufw allow 25`

`$ sudo ufw allow 110`

`$ sudo ufw allow 143`

`$ sudo ufw allow 3306`

<br>

`$ sudo ufw enable`

`$ sudo ufw status`

<br>

**ACCESO Y PRUEBA VÍA BROWSER DEL USUARIO.**

<br>

12. Ingrese en el browser del usuario la URL del servicio de correo electrónico:

<br>

`[http://mail.so2.local](http://mail.so2.local)`
