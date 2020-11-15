setup_route() {
    sleep 6

    ip rule add fwmark 1 table 100
    ip route add local 0.0.0.0/0 dev lo table 100


    iptables -t mangle -N V2RAY
    iptables -t mangle -A V2RAY -d 127.0.0.1/32 -j RETURN
    iptables -t mangle -A V2RAY -d 224.0.0.0/4 -j RETURN
    iptables -t mangle -A V2RAY -d 255.255.255.255/32 -j RETURN
    iptables -t mangle -A V2RAY -d 192.168.0.0/16 -p tcp -j RETURN
    iptables -t mangle -A V2RAY -d 192.168.0.0/16 -p udp ! --dport 53 -j RETURN
    iptables -t mangle -A V2RAY -p udp -j TPROXY --on-port 12345 --tproxy-mark 1
    iptables -t mangle -A V2RAY -p tcp -j TPROXY --on-port 12345 --tproxy-mark 1
    iptables -t mangle -A PREROUTING -j V2RAY

    iptables -t mangle -N V2RAY_MASK
    iptables -t mangle -A V2RAY_MASK -d 224.0.0.0/4 -j RETURN
    iptables -t mangle -A V2RAY_MASK -d 255.255.255.255/32 -j RETURN
    iptables -t mangle -A V2RAY_MASK -d 192.168.0.0/16 -p tcp -j RETURN
    iptables -t mangle -A V2RAY_MASK -d 192.168.0.0/16 -p udp ! --dport 53 -j RETURN
    iptables -t mangle -A V2RAY_MASK -j RETURN -m mark --mark 0xff
    iptables -t mangle -A V2RAY_MASK -p udp -j MARK --set-mark 1
    iptables -t mangle -A V2RAY_MASK -p tcp -j MARK --set-mark 1
    iptables -t mangle -A OUTPUT -j V2RAY_MASK
}

start_route() {
    iptables -t mangle -A PREROUTING -j V2RAY
    iptables -t mangle -A OUTPUT -j V2RAY_MASK
}

stop_route() {
    iptables -t mangle -D PREROUTING -j V2RAY
    iptables -t mangle -D OUTPUT -j V2RAY_MASK
}

fix_route_loop() {
    if `ip route |grep -q "default via 192.168.10.2 dev eth0"`; then
      ip route del default via 192.168.10.2 dev eth0
      ip route add default via 192.168.10.1 dev eth0 metric 0
    fi
}

[ $# -gt 0 ] && arg=$1
[ "x$arg" = "x" ] && setup_route && fix_route_loop
[ "x$arg" = "xstart" ] && start_route
[ "x$arg" = "xstop" ] && stop_route
