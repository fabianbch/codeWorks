#!/bin/bash
set -e
IP=$(hostname -I | awk '{print $1}')
INT=$(ip -o link | awk -F': ' '!/lo/ {print $2}' | cut -d@ -f1 | head -1)
apt update -qq && apt install -y openvpn easy-rsa ufw
mkdir -p /etc/openvpn/server/easy-rsa /var/log/openvpn
cp -r /usr/share/easy-rsa/* /etc/openvpn/server/easy-rsa/
cd /etc/openvpn/server/easy-rsa
./easyrsa init-pki
printf "CA\n" | ./easyrsa build-ca nopass
printf "server\n" | ./easyrsa gen-req server nopass
printf "yes\n" | ./easyrsa sign-req server server
./easyrsa gen-dh
openvpn --genkey --secret pki/ta.key
echo "port 1194" > /etc/openvpn/server/server.conf
echo "proto udp" >> /etc/openvpn/server/server.conf
echo "dev tun" >> /etc/openvpn/server/server.conf
echo "ca /etc/openvpn/server/easy-rsa/pki/ca.crt" >> /etc/openvpn/server/server.conf
echo "cert /etc/openvpn/server/easy-rsa/pki/issued/server.crt" >> /etc/openvpn/server/server.conf
echo "key /etc/openvpn/server/easy-rsa/pki/private/server.key" >> /etc/openvpn/server/server.conf
echo "dh /etc/openvpn/server/easy-rsa/pki/dh.pem" >> /etc/openvpn/server/server.conf
echo "tls-auth /etc/openvpn/server/easy-rsa/pki/ta.key 0" >> /etc/openvpn/server/server.conf
echo "topology subnet" >> /etc/openvpn/server/server.conf
echo "server 10.8.0.0 255.255.255.0" >> /etc/openvpn/server/server.conf
echo "ifconfig-pool-persist ipp.txt" >> /etc/openvpn/server/server.conf
echo "push \"route 10.8.0.0 255.255.255.0\"" >> /etc/openvpn/server/server.conf
echo "push \"dhcp-option DNS 8.8.8.8\"" >> /etc/openvpn/server/server.conf
echo "keepalive 10 120" >> /etc/openvpn/server/server.conf
echo "cipher AES-256-GCM" >> /etc/openvpn/server/server.conf
echo "auth SHA256" >> /etc/openvpn/server/server.conf
echo "user nobody" >> /etc/openvpn/server/server.conf
echo "group nogroup" >> /etc/openvpn/server/server.conf
echo "persist-key" >> /etc/openvpn/server/server.conf
echo "persist-tun" >> /etc/openvpn/server/server.conf
echo "status /var/log/openvpn/status.log" >> /etc/openvpn/server/server.conf
echo "log /var/log/openvpn/openvpn.log" >> /etc/openvpn/server/server.conf
echo "verb 3" >> /etc/openvpn/server/server.conf
echo "key-direction 0" >> /etc/openvpn/server/server.conf
echo "net.ipv4.ip_forward=1" > /etc/sysctl.d/99-openvpn.conf
sysctl -p /etc/sysctl.d/99-openvpn.conf
ufw --force reset && ufw allow 22/tcp && ufw allow 1194/udp && ufw --force enable
echo "*nat" >> /etc/ufw/before.rules
echo ":POSTROUTING ACCEPT [0:0]" >> /etc/ufw/before.rules
echo "-A POSTROUTING -s 10.8.0.0/24 -o $INT -j MASQUERADE" >> /etc/ufw/before.rules
echo "COMMIT" >> /etc/ufw/before.rules
systemctl daemon-reload && systemctl enable --now openvpn-server@server.service
sleep 2
pgrep openvpn && echo "[OK] OpenVPN activo en $IP:1194" || echo "[WARN] Iniciar manualmente"