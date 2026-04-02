# EN UBUNTU SERVER (Servidor)

1. Instalar servidor OpenVPN
Code[
wget -O install-openvpn-server.sh <URL_DEL_SCRIPT>
chmod +x install-openvpn-server.sh
sudo ./install-openvpn-server.sh]

3. Crear usuarios VPN
wget -O create-vpn-users.sh <URL_DEL_SCRIPT>
chmod +x create-vpn-users.sh
sudo ./create-vpn-users.sh

4. Verificar
ls -lh /root/vpn-clients/
systemctl status openvpn-server@server.service


# EN KALI LINUX (Cliente)

1. Descargar configuración
mkdir -p ~/vpn-configs
scp root@SERVER_IP:/root/vpn-clients/vpn1.ovpn ~/vpn-configs/

2. Conectar
sudo openvpn --config ~/vpn-configs/vpn1.ovpn --daemon

3. Verificar
ip addr show tun0
curl ifconfig.me
