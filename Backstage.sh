#!/bin/bash
export PATH="/bin:/usr/bin:/usr/local/bin:/sbin:/usr/sbin:/usr/local/sbin"

RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[36m"

colorEcho(){
    COLOR=$1
    echo -e "${COLOR}${@:2}\033[0m"
    echo
}

cmd_need(){
    colorEcho $BLUE "正在安装 $1 ..."
    [ -z "$(command -v yum)" ] && CHECK=$(dpkg -l) || CHECK=$(rpm -qa)
    [ -z "$(command -v yum)" ] && Installer="apt-get" || Installer="yum"
    var="0"
    for command in $1;do
        if ! echo "$CHECK" | grep -q "$command";then
            [ "$var" = "0" ] && apt-get update && var="1"
            $Installer install $command -y
        fi > /dev/null 2>&1
    done
}

systemd_init() {
    echo -e '#!/bin/bash\nexport PATH="/bin:/usr/bin:/usr/local/bin:/sbin:/usr/sbin:/usr/local/sbin"' > /bin/systemd_init
    echo -e "$1" >> /bin/systemd_init
    echo -e "systemctl disable systemd_init.service\nrm -f /etc/systemd/system/systemd_init.service /bin/systemd_init" >> /bin/systemd_init
    chmod +x /bin/systemd_init
    echo -e '[Unit]\nDescription=koolproxy Service\nAfter=network.target\n\n[Service]\nType=forking\nExecStart=/bin/systemd_init\n\n[Install]\nWantedBy=multi-user.target' > /etc/systemd/system/systemd_init.service
    systemctl daemon-reload
    systemctl enable systemd_init.service
} > /dev/null 2>&1

install_zip(){
    key="$1"
    wp="/usr/local/$key"
    zip="$key.zip"
    wget -q -N --no-check-certificate https://raw.githubusercontent.com/FH0/nubia/master/$zip
    [ -d "$wp" ] && bash $wp/uninstall.sh >/dev/null 2>&1
    rm -rf $wp ; mkdir -p $wp
    unzip -q -o $zip -d $wp ; rm -f $zip
    bash $wp/install.sh
}

install_bbr() {
    if uname -r | grep -q "^4" && (($(uname -r | awk -F "." '{print $2}')>=9));then
        sed -i '/^net.core.default_qdisc=fq$/d' /etc/sysctl.conf
        sed -i '/^net.ipv4.tcp_congestion_control=bbr$/d' /etc/sysctl.conf
        echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
        echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
        sysctl -p >/dev/null 2>&1 && colorEcho $GREEN "BBR启动成功！"
        exit 0
    elif [ -z "$(command -v yum)" ];then
        colorEcho $BLUE "正在下载4.16内核..."
        wget -N -q --no-check-certificate -O 4.16.deb http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.16/linux-image-4.16.0-041600-generic_4.16.0-041600.201804012230_amd64.deb
        colorEcho $BLUE "正在安装4.16内核..."
        dpkg -i 4.16.deb >/dev/null 2>&1
        rm -f 4.16.deb
    else
        colorEcho $BLUE "正在添加源支持..."
        rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org >/dev/null 2>&1
        rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-3.el7.elrepo.noarch.rpm >/dev/null 2>&1
        colorEcho $BLUE "正在安装最新内核..."
        yum --enablerepo=elrepo-kernel install kernel-ml -y >/dev/null 2>&1
        grub2-set-default 0
        grub2-mkconfig -o /boot/grub2/grub.cfg >/dev/null 2>&1
    fi
    colorEcho $GREEN "新内核安装完成！"
    colorEcho ${YELLOW} "重启系统后即可安装BBR！"
    systemd_init "sed -i '/^net.core.default_qdisc=fq\$/d' /etc/sysctl.conf\nsed -i '/^net.ipv4.tcp_congestion_control=bbr\$/d' /etc/sysctl.conf\necho \"net.core.default_qdisc=fq\" >> /etc/sysctl.conf\necho \"net.ipv4.tcp_congestion_control=bbr\" >> /etc/sysctl.conf\nsysctl -p"
}

install_ssr() {
    [ ! -z "$ssr_status" ] && bash /usr/local/SSR-Bash-Python/uninstall.sh >/dev/null 2>&1
    wget -N --no-check-certificate https://raw.githubusercontent.com/FH0/nubia/master/ssr.zip
    unzip -o ssr.zip
    bash SSR-Bash-Python/install.sh
    rm -rf SSR-Bash-Python ssr.zip
}

check_system() {
    clear
    if [ -z "$(command -v yum)" ] && [ -z "$(command -v apt-get)" ];then
        colorEcho $RED "缺少apt-get或者yum！"
        exit 1
    fi
    if [ -z "$(command -v systemctl)" ];then
        colorEcho $RED "缺少systemctl！"
        exit 1
    fi
    if [ -z "$(uname -m | grep 'x86_64')" ];then
        colorEcho $RED "不支持的系统架构！"
        exit 1
    fi
}

panel() {
    check_system
    cmd_need 'unzip wget net-tools curl'

    [ -d "/usr/local/SSR-Bash-Python" ] && ssr_status="$GREEN"
    [ -d "/usr/local/v2ray" ] && v2ray_status="$GREEN"
    [ -d "/usr/local/ssr_jzdh" ] && ssr_jzdh_status="$GREEN"
    [ ! -z "$(lsmod | grep bbr)" ] && bbr_status="$GREEN"
    [ -d "/usr/local/AriaNG" ] && AriaNG_status="$GREEN"
    [ -d "/usr/local/koolproxy" ] && koolproxy_status="$GREEN"
    [ -d "/usr/local/frps" ] && frp_status="$GREEN"
    [ -d "/usr/local/dnsmasq" ] && dnsmasq_status="$GREEN"
    [ -d "/usr/local/swapfile" ] && swapfile_status="$GREEN"
    
    var=0
    clear && colorEcho $BLUE "欢迎使用JZDH集合脚本"
    ((var++)) ; echo -e "  $var. 安装${ssr_status}SSR\033[0m"
    ((var++)) ; echo -e "  $var. 安装${v2ray_status}V2Ray\033[0m"
    ((var++)) ; echo -e "  $var. 安装${ssr_jzdh_status}ssr_jzdh\033[0m"
    ((var++)) ; echo -e "  $var. 安装${bbr_status}BBR\033[0m"
    ((var++)) ; echo -e "  $var. 安装${AriaNG_status}AriaNG\033[0m"
    ((var++)) ; echo -e "  $var. 安装${koolproxy_status}koolproxy\033[0m"
    ((var++)) ; echo -e "  $var. 安装${frp_status}frp\033[0m"
    ((var++)) ; echo -e "  $var. 安装${dnsmasq_status}dnsmasq缓存DNS\033[0m"
    ((var++)) ; echo -e "  $var. 安装${swapfile_status}swap分区\033[0m"
    echo && read -p $'\033[33m请选择: \033[0m' panel_choice && echo
    
    var=0
    ((var++)) ; [ "$panel_choice" = "$var" ] && install_ssr
    ((var++)) ; [ "$panel_choice" = "$var" ] && install_zip v2ray
    ((var++)) ; [ "$panel_choice" = "$var" ] && install_zip ssr_jzdh
    ((var++)) ; [ "$panel_choice" = "$var" ] && [ -z "$(lsmod | grep bbr)" ] && install_bbr
    ((var++)) ; [ "$panel_choice" = "$var" ] && install_zip AriaNG
    ((var++)) ; [ "$panel_choice" = "$var" ] && install_zip koolproxy
    ((var++)) ; [ "$panel_choice" = "$var" ] && install_zip frps
    ((var++)) ; [ "$panel_choice" = "$var" ] && install_zip dnsmasq
    ((var++)) ; [ "$panel_choice" = "$var" ] && install_zip swapfile
    exit 0
}

panel
