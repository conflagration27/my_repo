#!/bin/bash
# =============================================================================
# FIREWALL RULES FOR TEST PROJECT
# Применять ТОЛЬКО один блок в зависимости от роли ВМ
# =============================================================================

# =============================================================================
# Для Ubuntu - Backend + PostgreSQL
# =============================================================================
apply_backend_rules() {
    iptables -F
    iptables -X
    iptables -P INPUT DROP
    iptables -P FORWARD DROP
    iptables -P OUTPUT ACCEPT

    # Loopback
    iptables -A INPUT -i lo -j ACCEPT

    # ESTABLISHED connections
    iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

    # SSH
    iptables -A INPUT -p tcp --dport 22 -j ACCEPT

    # Backend API: только от Proxy (192.168.200.11)
    iptables -A INPUT -p tcp -s 192.168.200.11 --dport 8080 -j ACCEPT

    # PostgreSQL: только локально
    iptables -A INPUT -p tcp -s 127.0.0.1 --dport 5432 -j ACCEPT
    iptables -A INPUT -p tcp -s 192.168.200.10 --dport 5432 -j ACCEPT

    # ICMP (ping)
    iptables -A INPUT -p icmp -j ACCEPT

    # Логирование (опционально)
    iptables -A INPUT -j LOG --log-prefix "IPT_DROP: " --log-level 4
}

# =============================================================================
#  Для CentOS - Proxy + Redis
# =============================================================================
apply_proxy_rules() {
    iptables -F
    iptables -X
    iptables -P INPUT DROP
    iptables -P FORWARD DROP
    iptables -P OUTPUT ACCEPT

    # Loopback
    iptables -A INPUT -i lo -j ACCEPT

    # ESTABLISHED connections
    iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

    # SSH
    iptables -A INPUT -p tcp --dport 22 -j ACCEPT

    # Proxy API: от ВСЕХ
    iptables -A INPUT -p tcp --dport 5000 -j ACCEPT

    # Redis: только локально
    iptables -A INPUT -p tcp -s 127.0.0.1 --dport 6379 -j ACCEPT

    # ICMP
    iptables -A INPUT -p icmp -j ACCEPT
}

# =============================================================================
# Раскомментируй одну строку в зависимости от роли ВМ:
# =============================================================================
# apply_backend_rules   # <-- для Ubuntu/Backend
# apply_proxy_rules       # <-- для CentOS/Proxy
