@echo off
REM ============================================================
REM  Equipo de pruebas en las VLAN de usuarios (DHCP)
REM  Ejecutar como administrador. Ajustar el nombre de la tarjeta.
REM ============================================================
set TARJETA=Ethernet0 2

netsh interface ip set address name="%TARJETA%" dhcp
netsh interface ip set dns name="%TARJETA%" dhcp
ipconfig /release
ipconfig /renew
ipconfig
pause
