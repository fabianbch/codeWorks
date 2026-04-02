# Despliegue de DVWA en Docker

1: Instalar Docker en Ubuntu

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


Paso 2: Crear Directorio para DVWA

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
  dvwa-db-

networks:
  dvwa-network:
    driver: bridge
```

Paso 4: Iniciar DVWA

Desde el directorio ~/dvwa
```
cd ~/dvwa
```

Iniciar contenedores
```
docker-compose up -d
```

Ver estado
```
docker-compose ps
```

Ver logs
```
docker-compose logs -f
```

Paso 5: Configurar DVWA (Primera Vez)

Abrir navegador (Firefox/Chrome en Kali)
```
http://SERVER_IP
````

Hacer clic en "Create / Reset Database"


Esperar a que se cree la base de datos


Login con credenciales por defecto:
Usuario: `admin`
Contraseña: `password`


Cambiar nivel de seguridad (esquina superior derecha):
Ir a: `DVWA Security`
Seleccionar: `Low, Medium, o High`
Click: `Submit`
