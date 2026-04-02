# EN UBUNTU SERVER (Servidor)

1. Instalar servidor OpenVPN
```
nano install-openvpn-server.sh
chmod +x install-openvpn-server.sh
sudo ./install-openvpn-server.sh
```

3. Crear usuarios VPN
```
nano create-vpn-users.sh
chmod +x create-vpn-users.sh
sudo ./create-vpn-users.sh
```

4. Verificar
```
ls -lh /root/vpn-clients/
systemctl status openvpn-server@server.service
```



# EN KALI LINUX (Cliente)

1. Descargar configuración
```
mkdir -p ~/vpn-configs
scp root@SERVER_IP:/root/vpn-clients/vpn1.ovpn ~/vpn-configs/
```

2. Conectar
```
sudo openvpn --config ~/vpn-configs/vpn1.ovpn --daemon
```

3. Verificar
```
ip addr show tun0
curl ifconfig.me
ping -c 3 10.8.0.1
ip route show | grep -E "(default|10.8.0)"
```

5: Desconectar VPN
```
sudo pkill openvpn
sudo ip link delete tun0 2>/dev/null
ip addr show tun0
```
