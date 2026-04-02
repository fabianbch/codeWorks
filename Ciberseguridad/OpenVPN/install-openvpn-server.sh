#!/bin/bash
set -e

# Variables
IP=$(hostname -I | awk '{print $1}')
INT=$(ip -o link | awk -F': ' '!/lo/ {print $2}' | cut -d@ -f1 | head -1)

# Instalar paquetes
apt update -qq
apt install -y openvpn easy-rsa ufw

# Directorios
mkdir -p /etc/openvpn/server/easy-rsa /var/log/openvpn

# Copiar Easy-RSA
cp -r /usr/share/easy-rsa/* /etc/openvpn/server/easy-rsa/
cd /etc/openvpn/server/easy-rsa

# Generar PKI
./easyrsa init-pki
echo "CA" | ./easyrsa build-ca nopass
echo "server" | ./easyrsa gen-req server nopass
echo "yes" | ./easyrsa sign-req server server
./easyrsa gen-dh
openvpn --genkey --secret pki/ta.key

# Configuración del servidor
cat > /etc/openvpn/server/server.conf << 'ENDCONF'
port 1194
proto udp
dev tun
ca /etc/openvpn/server/easy-rsa/pki/ca.crt
cert /etc/openvpn/server/easy-rsa/pki/issued/server.crt
key /etc/openvpn/server/easy-rsa/pki/private/server.key
dh /etc/openvpn/server/easy-rsa/pki/dh.pem
tls-auth /etc/openvpn/server/easy-rsa/pki/ta.key 0
topology subnet
server 10.8.0.0 255.255.255.0
ifconfig-pool-persist ipp.txt
push "route 10.8.0.0 255.255.255.0"
push "dhcp-option DNS 8.8.8.8"
keepalive 10 120
cipher AES-256-GCM
auth SHA256
user nobody
group nogroup
persist-key
persist-tun
status /var/log/openvpn/status.log
log /var/log/openvpn/openvpn.log
verb 3
key-direction 0
ENDCONF

# Habilitar IP Forwarding
echo "net.ipv4.ip_forward=1" > /etc/sysctl.d/99-openvpn.conf
sysctl -p /etc/sysctl.d/99-openvpn.conf

# Configurar UFW
ufw --force reset
ufw default deny incoming
ufw default allow outgoing
ufw allow 22/tcp
ufw allow 1194/udp
ufw --force enable

# Configurar NAT
echo "" >> /etc/ufw/before.rules
echo "*nat" >> /etc/ufw/before.rules
echo ":POSTROUTING ACCEPT [0:0]" >> /etc/ufw/before.rules
echo "-A POSTROUTING -s 10.8.0.0/24 -o $INT -j MASQUERADE" >> /etc/ufw/before.rules
echo "COMMIT" >> /etc/ufw/before.rules

# Iniciar servicio
systemctl daemon-reload