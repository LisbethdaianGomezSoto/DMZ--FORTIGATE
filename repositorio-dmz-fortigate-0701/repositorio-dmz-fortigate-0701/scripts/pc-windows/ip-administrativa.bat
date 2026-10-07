@echo off
REM ============================================================
REM  PC administrativa (conectada al Port4 del FortiGate)
REM  IP fija 10.7.71.2/29  |  Gateway 10.7.71.1
REM  Ejecutar como administrador. Ajustar el nombre de la tarjeta.
REM ============================================================
set TARJETA=Ethernet0 2

netsh interface ip set address name="%TARJETA%" static 10.7.71.2 255.255.255.248 10.7.71.1
netsh interface ip set dns name="%TARJETA%" static 10.7.71.1
ipconfig
ping 10.7.71.1
echo.
echo Abrir en el navegador: https://10.7.71.1
pause
