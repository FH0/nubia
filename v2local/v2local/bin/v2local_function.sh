
#准备和检查
shopt -s expand_aliases >/dev/null 2>&1
for C in $($wp/bin/busybox --list);do
    alias $C="$wp/bin/busybox $C"
done
if grep -q "TPROXY" /proc/net/ip_tables_targets;then
    proxy_mode="notun"
elif [ "$(getprop ro.build.version.sdk)" -ge "21" ];then
    proxy_mode="tun"
else
    echo "不支持的设备，安卓版本低于 5.0 或缺少 TPROXY 模块"
    exit 1
fi
export PATH="/system/bin:$PATH"
allow_ip="0.0.0.0/8,100.64.0.0/10,127.0.0.0/8,169.254.0.0/16,192.0.0.0/24,192.0.2.0/24,192.88.99.0/24,198.18.0.0/15,198.51.100.0/24,203.0.113.0/24,172.16.0.0/12,192.168.0.0/16,10.0.0.0/8,224.0.0.0/3"
if iptables --help | grep -q "xtable";then
    alias iptables="iptables -w"
else
    iptables() {
        /system/bin/iptables $@
        tmp="$?"
        [ "$tmp" = "4" ] && iptables $@
        return $tmp
    }
fi
. $wp/bin/config_function.sh
last_file="香港分流.sh"

record_file_name() {
    sed -i "s|^last_file=.*|last_file=\"${0##*/}\"|" $wp/bin/v2local_function.sh
}

v2local_status(){
    echo
    if [ "$proxy_mode" != "notun" ];then
        if [ -z "$(pgrep tun2sockS)" -o "$v2local_cmd" = "stop" ];then
            tun2socks_status="○⊃ Tun2Socks"
        else
            tun2socks_status="⊂● Tun2Socks"
        fi
    fi
    if [ "$v2local_cmd" = "stop" ];then
        echo "    ○⊃ V2Ray    $tun2socks_status"
    else
        v2ray_status="○⊃" && [ -z "$(pgrep v2raY)" ] || v2ray_status="⊂●"
        echo "    $v2ray_status V2Ray    $tun2socks_status"
    fi

    iptables -t mangle -nvL | awk '{if(index($0,"match 1111")>0){print "\n    {本次代理的总流量}: "$2;exit}}'
    echo
    [ "$v2local_cmd" = "start" ] && last_file=${0##*/}
    echo "    {最近的启动文件}: $last_file"
#    echo
#    echo "    {日志}:"
#    echo "$(cat $wp/bin/v2local.log)"
}

v2local_bin_start(){
    setuidgid 0:1111 setsid $wp/bin/v2raY -config $wp/bin/config.json &
    if [ "$proxy_mode" != "notun" ];then
        setsid $wp/bin/tun2sockS --tundev v2local --netif-ipaddr 10.0.0.10 --netif-netmask 255.255.255.0 --socks-server-addr 127.0.0.1:1112 --enable-udprelay --loglevel 1 &
    fi
} >>$wp/bin/v2local.log 2>&1

add_rules(){
    #添加路由
    if [ "$proxy_mode" = "notun" ];then
        ip route add local default dev lo table 1112
    else
        ip link set v2local up
        ip route add default dev v2local table 1112
    fi
    ip rule add from all fwmark 0x1112 lookup 1112

    #初始化 iptables 规则
    iptables -N VFF
    iptables -I FORWARD -j VFF
    iptables -t nat -N VNO
    iptables -t nat -I OUTPUT -j VNO
    iptables -t nat -N VNP
    iptables -t nat -I PREROUTING -j VNP
    iptables -t mangle -N VMO
    iptables -t mangle -I OUTPUT -j VMO
    iptables -t mangle -N VMP
    iptables -t mangle -I PREROUTING -j VMP

    #基于 UID 的代理规则
    APP_UID=$(value=${app_proxy:-$app_direct} awk 'BEGIN{value=" "ENVIRON["value"]" ";for (match(value, " [0-9]+ ");RSTART>0;match(value, " [0-9]+ ")){output=substr(value, RSTART+1, RLENGTH-1);printf output;sub(output,"",value);}RS="<pkg ";FS="\""}{if(index(value, " "$2" ") > 0){printf $4" "}}' /data/system/appops.xml)
    if [ -z "$app_proxy" ];then
        iptables -t nat -I VNO -p 6 -j REDIRECT --to 1111
        iptables -t mangle -I VMO -p 17 -j MARK --set-xmark 0x1112
        for X in $APP_UID;do
            iptables -t nat -I VNO -m owner --uid-owner $X -j ACCEPT
            iptables -t mangle -I VMO -m owner --uid-owner $X -j ACCEPT
        done
    else
        for X in $APP_UID;do
            iptables -t nat -I VNO -p 6 -m owner --uid-owner $X -j REDIRECT --to 1111
            iptables -t mangle -I VMO -p 17 -m owner --uid-owner $X -j MARK --set-mark 0x1112
        done
    fi
    iptables -t nat -I VNO -d $allow_ip -j ACCEPT
    iptables -t nat -I VNO -o lo -j ACCEPT
    iptables -t nat -I VNO -o tun+ -j ACCEPT
    iptables -t nat -I VNO -o ap+ -j ACCEPT
    [ "$wifi_proxy" = "off" ] && iptables -t nat -I VNO -o wlan+ -j ACCEPT
    iptables -t nat -I VNO -m owner --gid-owner 1111 -j ACCEPT

    iptables -t mangle -I VMO -d $allow_ip -j ACCEPT
    iptables -t mangle -I VMO -o lo -j ACCEPT
    if [ -z "$DNS" ];then
        iptables -t mangle -I VMO -p 17 --dport 53 -j ACCEPT
    else
        iptables -t mangle -I VMO -p 17 --dport 53 -j MARK --set-xmark 0x1112
    fi
    iptables -t mangle -I VMO -o tun+ -j ACCEPT
    iptables -t mangle -I VMO -o ap+ -j ACCEPT
    [ "$wifi_proxy" = "off" ] && iptables -t mangle -I VMO -o wlan+ -j ACCEPT
    iptables -t mangle -I VMO -m owner --gid-owner 1111 -j ACCEPT

    if [ "$proxy_mode" = "notun" ];then
        iptables -t mangle -I VMP -i lo -p 17 -j TPROXY --on-port 1112 --tproxy-mark 0x1112
        iptables -t mangle -I VMP -d $allow_ip -j ACCEPT
        if [ -z "$DNS" ];then
            iptables -t mangle -I VMP -i lo -p 17 --dport 53 -j ACCEPT
        else
            iptables -t mangle -I VMP -i lo -p 17 --dport 53 -j TPROXY --on-port 1112 --tproxy-mark 0x1112
        fi
    fi

    #热点代理规则
    if [ "$hot_proxy" = "on" ];then
        iptables -t nat -I VNP -s 192.168/16 -p 6 -j REDIRECT --to 1111
        iptables -t nat -I VNP -d 192.168/16 -j ACCEPT
        if [ "$proxy_mode" = "notun" ];then
            iptables -t mangle -I VMP 16 -s 192.168/16 -p 17 -j TPROXY --on-port 1112 --tproxy-mark 0x1112
        else
            iptables -I VFF -i v2local -j ACCEPT
            iptables -I VFF -o v2local -j ACCEPT
            iptables -t mangle -I VMP -s 192.168/16 -p 17 -j MARK --set-mark 0x1112
            iptables -t mangle -I VMP -d $allow_ip -j ACCEPT
        fi
    elif [ -z "$app_proxy" ];then
        iptables -t mangle -I VMO 2 -m owner --uid-owner 1052 -j ACCEPT
    fi

    #跳点控制
    if [ -z "$ChinaDNS" ];then
        iptables -t mangle -I VMO -p 1 -j DROP
        iptables -t mangle -I VMO -m state --state INVALID -j DROP
        iptables -t mangle -I VMP -m state --state INVALID -j DROP
    fi
}

magisk_auto_start(){
    [ ! -d "/data/adb/service.d" ] && return 1
    if [ "$auto_start" = "on" ];then
        echo | sed "1c#!/system/bin/sh\nwhile true;do\n    if [ -e \"$(readlink -f $0)\" ];then\n        sleep 30\n        sh $(readlink -f $0)\n        exit 0\n    else\n        sleep 3\n    fi\ndone" > /data/adb/service.d/v2local.sh
        chmod 755 /data/adb/service.d/v2local.sh
    else
        rm -f /data/adb/service.d/v2local.sh
    fi
}

v2local_permission(){
    chmod -R 777 .
    ! echo $(readlink -f $0) | grep -q "^/system" && return 0
    mount -o $1,remount /
    mount -o $1,remount /system
} >/dev/null 2>&1

v2local_stop() {
    killall -q v2raY tun2sockS
    ip rule | sed -n '/0x1112/{s|.*from|ip rule del from |g;p}' | sh
    ip route flush table 1112
    iptables -F VFF
    iptables -D FORWARD -j VFF
    iptables -X VFF
    iptables -t nat -F VNO
    iptables -t nat -D OUTPUT -j VNO
    iptables -t nat -X VNO
    iptables -t nat -F VNP
    iptables -t nat -D PREROUTING -j VNP
    iptables -t nat -X VNP
    iptables -t mangle -F VMO
    iptables -t mangle -D OUTPUT -j VMO
    iptables -t mangle -X VMO
    iptables -t mangle -F VMP
    iptables -t mangle -D PREROUTING -j VMP
    iptables -t mangle -X VMP
} >/dev/null 2>&1

if [ "$v2local_cmd" = "stop" ];then
    v2local_stop
elif [ "$v2local_cmd" = "start" ];then
    v2local_stop
    v2local_permission rw
    rm -f $wp/bin/*.log #删除无用文件
    vim_config
    v2local_bin_start
    record_file_name
    magisk_auto_start
    add_rules
    v2local_permission ro
fi
v2local_status
