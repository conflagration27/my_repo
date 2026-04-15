#!/bin/bash
# Очистка старых правил
iptables -F
iptables -X

# Политики по умолчанию
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

#Разрешаем Loopback (для работы localhost, например, curl с самого сервера)
iptables -A INPUT -i lo -j ACCEPT

#Разрешаем уже установленные соединения
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

#SSH 
iptables -A INPUT -p tcp --dport 22 -j ACCEPT

#Backend API (8080) только от Proxy (192.168.200.11)
iptables -A INPUT -p tcp -s 192.168.200.11 --dport 8080 -j ACCEPT

#PostgreSQL  только localhost
iptables -A INPUT -p tcp -s 127.0.0.1 --dport 5432 -j ACCEPT
iptables -A INPUT -p tcp -s 192.168.200.10 --dport 5432 -j ACCEPT

#ICMP
iptables -A INPUT -p icmp -j ACCEPT

#Логирование пакетов 
iptables -A INPUT -j LOG --log-prefix "IPTABLES_DROP: " --log-level 4

echo "Rules applied for this server"