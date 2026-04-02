#!/bin/bash
set -e
IP=$(hostname -I | awk '{print $1}'); INT=$(ip -o link | awk -F': ' '!/lo/ {print $2}' | cut -d@ -f1 | head -1)
apt update -qq && apt install -y openvpn easy-rsa ufw >/dev/null 2>&1
mkdir -p /etc/openvpn/server/easy-rsa /var/log/openvpn
cp -r /usr/share/easy-rsa/* /etc/openvpn/server/easy-rsa/
cd /etc/openvpn/server/easy-rsa && ./easyrsa init-pki >/dev/null 2>&1
echo "CA" | ./easyrsa build-ca nopass >/dev/null 2>&1
echo "server" | ./easyrsa gen-req server nopass >/dev/null 2>&1
echo "yes" | ./easyrsa sign-req server server >/dev/null 2>&1
./easyrsa gen-dh >/dev/null 2>&1 && openvpn --genkey --secret pki/ta.key >/dev/null 2>&1
cat > /etc/openvpn/server/server.conf << EOF
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
EOF
echo "net.ipv4.ip_forward=1" > /etc/sysctl.d/99-openvpn.conf && sysctl -p >/dev/null 2>&1
ufw --force reset >/dev/null 2>&1 && ufw allow 22/tcp && ufw allow 1194/udp && ufw --force enable >/dev/null 2>&1
cat >> /etc/ufw/before.rules << NAT
*nat
:POSTROUTING ACCEPT [0:0]
-A POSTROUTING -s 10.8.0.0/24 -o $INT -j MASQUERADE
COMMIT
NAT
systemctl daemon-reload && systemctl enable --now openvpn-server@server.service >/dev/null 2>&1
sleep 2; pgrep openvpn >/dev/null || openvpn --daemon --config /etc/openvpn/server/server.conf
echo "[OK] OpenVPN Server activo en $IP:1194"