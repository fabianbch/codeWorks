#!/bin/bash
set -e
IP=$(hostname -I | awk '{print $1}'); OUT="/root/vpn-clients"; mkdir -p $OUT
cd /etc/openvpn/server/easy-rsa
CA=$(cat pki/ca.crt); TA=$(cat pki/ta.key)
for i in {1..5}; do
  c="vpn$i"
  echo "$c" | ./easyrsa gen-req $c nopass >/dev/null 2>&1
  echo "yes" | ./easyrsa sign-req client $c >/dev/null 2>&1
  CRT=$(cat pki/issued/${c}.crt); KEY=$(cat pki/private/${c}.key)
  cat > $OUT/${c}.ovpn << EOF
client
dev tun
proto udp
remote $IP 1194
resolv-retry infinite
nobind
persist-key
persist-tun
verb 3
cipher AES-256-GCM
auth SHA256
key-direction 1
route-nopull
route 10.8.0.0 255.255.255.0
<ca>
$CA
</ca>
<cert>
$CRT
</cert>
<key>
$KEY
</key>
<tls-auth>
$TA
</tls-auth>
EOF
  chmod 600 $OUT/${c}.ovpn
done
echo "[OK] 5 clientes creados en $OUT/ (vpn1.ovpn - vpn5.ovpn)"