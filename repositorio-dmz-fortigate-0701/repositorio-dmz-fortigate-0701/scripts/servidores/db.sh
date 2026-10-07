#!/bin/sh
# ============================================================
#  Db-Server  |  10.7.1.4/28  |  Ubuntu 22.04
#  Uso: sh db.sh '<contraseña-de-root>'
# ============================================================
set -e
ROOT_PASS="${1:?Uso: sh db.sh '<contraseña-de-root>'}"
IP="10.7.1.4/28"
GW="10.7.1.1"
DNS="10.7.1.1"

echo "[1/4] Red"
ip addr show dev eth0 | grep -q "${IP%/*}" || ip addr add "$IP" dev eth0
ip route show default | grep -q . || ip route add default via "$GW"
echo "nameserver $DNS" > /etc/resolv.conf

echo "[2/4] Paquetes"
apt -o Acquire::ForceIPv4=true update
apt install -y --no-install-recommends openssh-server mariadb-server

echo "[3/4] SSH y MariaDB"
mkdir -p /run/sshd
sed -i 's/^#*PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
echo "root:${ROOT_PASS}" | chpasswd
service ssh restart
service mariadb start || true

echo "[4/4] Verificación"
service ssh status
mysql -e "SHOW DATABASES;"
ss -tlnp | grep -E ':22|:3306'
