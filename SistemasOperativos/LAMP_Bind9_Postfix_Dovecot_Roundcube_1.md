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


+-----------------------+                   +-------------------=---+

|  Host: www.so2.local  |  192.168.5.10/24  |  Host: mail.s02.world |

|   Apache2, MariaDB,   +---------+---------+  Postfix, POP3, IMAP, |

|      Php, Bind9,      |                   |         Dovecot       |

|   Webmail Roundcube   |                   |                       |

+-----------------------+                   +------------------=----+


1. Actualizar el sistema:

`$ sudo apt update && sudo apt upgrade`


**PRE-REQUISITOS MANDATORIOS**
**==========================**

2. Configurar el hostname:

`$ sudo hostnamectl set-hostname master.so2.local`

`$ echo "192.168.5.10 master.so2.local mail.so2.local" | sudo tee -a /etc/hosts`

3. Configurar zona horaria:

`$ sudo timedatectl`

4. Eliminar configuraciones previas:

`$ sudo apt remove --purge postfix dovecot-core dovecot-imapd dovecot-pop3d roundcube roundcube-core roundcube-mysql`

`$ sudo apt autoremove`

`$ sudo apt autoclean`

`$ sudo rm -rf /etc/postfix /etc/dovecot`
