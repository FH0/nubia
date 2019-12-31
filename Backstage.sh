#!/bin/bash
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[36m"
BLANK="\033[0m"

colorEcho(){
    COLOR=$1
    echo -e "${COLOR}${@:2}${BLANK}"
    echo
}

colorRead(){
    COLOR=$1
    OUTPUT=$2
    VARIABLE=$3
    echo -e -n "$COLOR$OUTPUT${BLANK}: "
    read $VARIABLE
    echo
}

cmd_need(){
    [ -z "$(command -v yum)" ] && CHECK=$(dpkg -l) || CHECK=$(rpm -qa)
    for command in $1;do
        echo "$CHECK" | grep -q "$command" || CMD="$command $CMD"
    done
    if [ ! -z "$CMD" ];then
		colorEcho $BLUE "正在安装 $CMD ..."
		if [ -z "$(command -v yum)" ];then
			apt-get update
			apt-get install $CMD -y
		else
			yum install $CMD -y
		fi > /dev/null 2>&1
		clear
	fi
}

install_zip(){
    key="$1"
    wp="/usr/local/$key"
    zip="$key.zip"
    colorEcho $YELLOW "正在安装 $key 到 $wp..." 
    curl -sOL https://raw.githubusercontent.com/FH0/nubia/master/server_script/$zip
    [ -d "$wp" ] && bash $wp/uninstall.sh >/dev/null 2>&1
    rm -rf $wp ; mkdir -p $wp
    unzip -q -o $zip -d $wp ; rm -f $zip
    bash $wp/install.sh
}

check_system() {
    clear
    if [ -z "$(command -v yum apt-get)" ];then
        colorEcho $RED "不支持的操作系统！"
        exit 1
    elif ! uname -m | grep -q 'x86_64';then
        colorEcho $RED "不支持的系统架构！"
        exit 1
    fi
}

jzdh_add(){
	JZDH_ZIP+="$1 $2\n"
}

panel() {
    check_system
    cmd_need 'wget iproute unzip net-tools curl'
	
	jzdh_add "V2Ray"                    "v2ray"
	jzdh_add "ssr_jzdh"                 "ssr_jzdh"
	jzdh_add "BBR"                      "BBR"
	jzdh_add "AriaNG"                   "AriaNG"
	jzdh_add "frp"                      "frps"
	jzdh_add "swap 分区"                "ssr_jzdh"
	jzdh_add "oneindex"                 "oneindex"
	jzdh_add "openvpn"                  "openvpn"
	jzdh_add "wireguard"                "wireguard"
	jzdh_add "tinyvpn-udp2raw"          "tinyvpn"
	jzdh_add "smartdns"                 "smartdns"
	jzdh_add "v2ray 透明代理"           "v2ray-proxy"
	
    colorEcho $BLUE "欢迎使用 JZDH 集合脚本"
    var=1
	echo -e "$JZDH_ZIP" | grep -Ev '^$' | while read zip;do
		zip_path="$(echo "$zip" | awk '{print $NF}')"
		zip_name="$(echo "$zip" | awk '{$NF=""; print $0}')"
		if [ -d "/usr/local/$zip_path" ];then
			printf "%3s. 安装 ${GREEN}$zip_name${BLANK}\n" "$((var++))"
		else
			printf "%3s. 安装 $zip_name\n" "$((var++))"
		fi
	done
    echo && colorRead ${YELLOW} '请选择' panel_choice

    for J in $panel_choice;do
        install_zip $(echo -e "$JZDH_ZIP" | sed -n "${J}p" | awk '{print $NF}')
    done
}

panel
