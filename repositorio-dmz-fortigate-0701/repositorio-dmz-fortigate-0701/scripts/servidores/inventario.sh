#!/bin/sh
# ============================================================
#  Web-Server-INVENTARIO  |  10.7.1.5/28  |  Ubuntu 22.04
#  Uso: sh inventario.sh '<contraseña-de-root>'
# ============================================================
set -e
ROOT_PASS="${1:?Uso: sh inventario.sh '<contraseña-de-root>'}"
IP="10.7.1.5/28"
GW="10.7.1.1"
DNS="10.7.1.1"

echo "[1/5] Red"
ip addr show dev eth0 | grep -q "${IP%/*}" || ip addr add "$IP" dev eth0
ip route show default | grep -q . || ip route add default via "$GW"
echo "nameserver $DNS" > /etc/resolv.conf

echo "[2/5] Paquetes"
apt -o Acquire::ForceIPv4=true update
apt install -y --no-install-recommends openssh-server apache2

echo "[3/5] Apache"
echo "ServerName localhost" > /etc/apache2/conf-available/servername.conf
a2enconf servername
echo "<h1>Sistema de Inventario</h1>" > /var/www/html/index.html
service apache2 restart

echo "[4/5] SSH"
mkdir -p /run/sshd
sed -i 's/^#*PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
echo "root:${ROOT_PASS}" | chpasswd
service ssh restart

echo "[5/5] Verificación"
service apache2 status
service ssh status
ss -tlnp | grep -E ':22|:80'
