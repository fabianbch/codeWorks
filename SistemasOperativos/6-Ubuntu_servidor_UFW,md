# Implementación de equipos de seguridad perimetral (firewall de host) en Ubuntu Server 24.04
**by [gWorks Cloud Solutions](https://www.gworks-ec.com)**

<br>

El sistema de seguridad perimetral de red, controla el tráfico entrante y saliente basado en reglas de seguridad predefinidas.

<br>

<img src="https://www.gworks-ec.com/nia/uploads/2024/07/Ubuntu_implementacion-e1721710717703.png">

<br>

1. Instalación del Firewall UFW:

`$ sudo apt install ufw`

<br>

2. Configuración del Firewall UFW con reglas por defecto:

<br>

`$ sudo ufw default deny incoming`

`$ sudo ufw default allow outgoing`

<br>

3. Asignación de reglas de tráfico SSH, HTTP, SFTP, DNS:

<br>

`$ sudo ufw allow 22`

`$ sudo ufw allow 80`

`$ sudo ufw allow 21`

`$ sudo ufw allow 53`

<br>

4. Ejecución automática del Firewall UFW:

<br>

`$ sudo ufw enable`

<br>

5. Estado del Firewall UFW para asegurar que está funcionando:

<br>

`$ sudo ufw status`
