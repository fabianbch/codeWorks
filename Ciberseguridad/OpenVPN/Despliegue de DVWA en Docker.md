# Despliegue de DVWA en Docker

1. Instalar Docker en Ubuntu

Actualizar sistema
```
sudo apt update
```

Instalar Docker
```
sudo apt install -y docker.io docker-compose
```

Agregar usuario al grupo docker (para no usar sudo)
```
sudo usermod -aG docker $USER
```

Iniciar y habilitar Docker
```
sudo systemctl enable docker
sudo systemctl start docker
```

Verificar instalación
```
docker --version
docker-compose --version
```


2. Crear el Directorio para DVWA

Crear directorio
```
mkdir -p ~/dvwa
cd ~/dvwa
```

Crear archivo docker-compose.yml
```
nano docker-compose.yml
```

Pegar este contenido, guardar y presionar Ctrl+X, Y, Enter
```
version: '3.8'

services:
  dvwa:
    image: vulnerables/web-dvwa:latest
    container_name: dvwa
    restart: always
    ports:
      - "80:80"
      - "443:443"
    environment:
      - DBMS=mysql
      - MYSQL_HOST=db
      - MYSQL_USER=dvwa
      - MYSQL_PASSWORD=p@ssw0rd
      - MYSQL_DATABASE=dvwa
    depends_on:
      - db
    networks:
      - dvwa-network

  db:
    image: mysql:5.7
    container_name: dvwa-db
    restart: always
    environment:
      - MYSQL_ROOT_PASSWORD=p@ssw0rd
      - MYSQL_DATABASE=dvwa
      - MYSQL_USER=dvwa
      - MYSQL_PASSWORD=p@ssw0rd
    volumes:
      - dvwa-db-data:/var/lib/mysql
    networks:
      - dvwa-network

volumes:
  dvwa-db-data:

networks:
  dvwa-network:
    driver: bridge
```

3. Iniciar la aplicación DVWA

Desde el directorio ~/dvwa
```
cd ~/dvwa
```

Iniciar contenedores
```
sudo docker-compose up -d
```

Ver estado
```
sudo docker-compose ps
```

Ver logs
```
sudo docker-compose logs -f
```

4. Configurar la aplicación DVWA por primera vez

Abrir navegador (Firefox/Chrome en Kali)
```
http://SERVER_IP o http://SERVER_IP_VPN
````

Hacer clic en "Create / Reset Database"

Esperar a que se cree la base de datos

Login con credenciales por defecto:
```
Usuario: admin
Contraseña: password
```

Cambiar nivel de seguridad (esquina superior derecha):
```
Ir a: DVWA Security
Seleccionar: Low, Medium, o High
Click: Submit
```
