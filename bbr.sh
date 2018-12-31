#!/bin/bash

debian_bbr() {
    sed -i '/^net.core.default_qdisc=fq$/d' /etc/sysctl.conf
    sed -i '/^net.ipv4.tcp_congestion_control=bbr$/d' /etc/sysctl.conf
    echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
    sysctl -p
}

centos_bbr() {
    clear && echo '过程需要10分钟左右，部分场景会卡住，耐心等待'
    echo
    sleep 3
    yum update -y
    rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
    rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-2.el7.elrepo.noarch.rpm
    yum --enablerepo=elrepo-kernel install kernel-ml -y
    grub2-set-default 0
    echo -e '[Unit]\nDescription=/etc/rc.local\nConditionPathExists=/etc/rc.local\n\n[Service]\nType=forking\nExecStart=/etc/rc.local start\nTimeoutSec=0\nStandardOutput=tty\nRemainAfterExit=yes\nSysVStartPriority=99\n\n[Install]\nWantedBy=multi-user.target' > /etc/systemd/system/rc-local.service
    echo -e "#!/bin/bash\nsed -i '/^net.core.default_qdisc=fq$/d' /etc/sysctl.conf\nsed -i '/^net.ipv4.tcp_congestion_control=bbr$/d' /etc/sysctl.conf\necho 'net.core.default_qdisc=fq' >> /etc/sysctl.conf\necho 'net.ipv4.tcp_congestion_control=bbr' >> /etc/sysctl.conf\nsysctl -p\necho -e '#!/bin/sh -e\nexit 0' > /etc/rc.local\nexit 0" > /etc/rc.local
    chmod +x /etc/rc.local
    systemctl enable rc-local
    systemctl start rc-local.service
}

main() {
    [ -f "/usr/bin/apt-get" ] && debian_bbr
    [ -f "/usr/bin/yum" ] && centos_bbr
    clear && echo 'BBR安装完成，请重启系统'
}

main
