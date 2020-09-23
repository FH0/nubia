#!/bin/bash
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[36m"
BLANK="\033[0m"

colorEcho() {
    COLOR=$1
    shift # delete first parameter
    echo -e "${COLOR}${@}${BLANK}"
    echo
}

colorRead() {
    COLOR=$1
    OUTPUT=$2
    VARIABLE=$3
    echo -e -n "$COLOR$OUTPUT${BLANK}: "
    read $VARIABLE
    echo
}

cmd_need() {
    update_flag=0
    exit_flag=0

    for cmd in $1; do
        if type $cmd 2>&1 | grep -q ": not found"; then
            # check if auto install
            if type apt >/dev/null; then
                # apt install package need update first
                if [ "update_flag" = "0" ]; then
                    apt update >/dev/null 2>&1
                    update_flag=1
                fi

                package=$(dpkg -S bin/$cmd 2>&1 | grep "bin/$cmd$" | awk -F':' '{print $1}')
                if [ ! -z "$package" ]; then
                    colorEcho $BLUE "正在安装 $cmd ..."
                    apt install $package -y >/dev/null 2>&1
                    continue
                fi
            elif type yum >/dev/null; then
                package=$(yum whatprovides *bin/$cmd 2>&1 | grep " : " | awk -F' : ' '{print $1}' | sed -n '1p')
                if [ ! -z "$package" ]; then
                    colorEcho $BLUE "正在安装 $cmd ..."
                    yum install $package -y >/dev/null 2>&1
                    continue
                fi
            fi

            colorEcho $RED "找不到 $cmd 命令"
            exit_flag=1
        fi
    done

    if [ "$exit_flag" = "1" ]; then
        exit 1
    fi
}

install_zip() {
    key="$1"
    wp="/usr/local/$key"
    zip="$key.zip"
    if [ -d "$wp" ]; then
        colorEcho $YELLOW "正在卸载 $key..."
        bash $wp/uninstall.sh >/dev/null 2>&1
    fi
    colorEcho $YELLOW "正在安装 $key 到 $wp..."
    curl -sOL https://github.com/q65686488/nubia/master/server_script/$zip
    rm -rf $wp
    mkdir -p $wp
    unzip -q -o $zip -d $wp
    rm -f $zip
    bash $wp/install.sh
}

check_environment() {
    # if [ -z "$(command -v yum apt-get)" ]; then
    #     colorEcho $RED "不支持的操作系统！"
    #     exit 1
    # elif ! uname -m | grep -q 'x86_64'; then
    #     colorEcho $RED "不支持的系统架构！"
    #     exit 1
    # fi

    if [ "$(id -u)" != "0" ]; then
        colorEcho $RED "请切换到root用户后再执行此脚本！"
        exit 1
    fi

    if [ "$(uname -r | awk -F '.' '{print $1}')" -lt "3" ]; then
        colorEcho $RED "内核太老，请升级内核或更新系统！"
        exit 1
    fi
}

jzdh_add() {
    JZDH_ZIP+="$1 $2\n"
}

panel() {
    clear

    check_environment
    cmd_need 'iptables unzip netstat curl'

    jzdh_add "V2Ray" "v2ray"
    jzdh_add "ssr_jzdh" "ssr_jzdh"
    jzdh_add "BBR" "BBR"
    jzdh_add "AriaNG" "AriaNG"
    jzdh_add "frp" "frps"
    jzdh_add "swap 分区" "ssr_jzdh"
    jzdh_add "oneindex" "oneindex"
    jzdh_add "openvpn" "openvpn"
    jzdh_add "wireguard" "wireguard"
    jzdh_add "tinyvpn-udp2raw" "tinyvpn"
    jzdh_add "smartdns" "smartdns"
    jzdh_add "tun2socks-v2ray 透明代理" "tun2socks"
    jzdh_add "v2ray 透明代理（TPROXY + REDIRECT）" "v2rayT"
    jzdh_add "ygk" "ygk"

    colorEcho $BLUE "欢迎使用 JZDH 集合脚本"
    var=1
    echo -e "$JZDH_ZIP" | grep -Ev '^$' | while read zip; do
        zip_path="$(echo "$zip" | awk '{print $NF}')"
        zip_name="$(echo "$zip" | awk '{$NF=""; print $0}')"
        if [ -d "/usr/local/$zip_path" ]; then
            printf "%3s. 安装 ${GREEN}$zip_name${BLANK}\n" "$((var++))"
        else
            printf "%3s. 安装 $zip_name\n" "$((var++))"
        fi
    done
    echo && colorRead ${YELLOW} '请选择' panel_choice
    [ -z "$panel_choice" ] && clear && exit 0
    for J in $panel_choice; do
        install_zip $(echo -e "$JZDH_ZIP" | sed -n "${J}p" | awk '{print $NF}')
    done
}

panel
