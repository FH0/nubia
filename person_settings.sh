#!/bin/bash
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

handle_sshd_config() {
    mkdir -p /root/.ssh
	chmod 700 /root/.ssh
    echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDuwLr5N5CxF51tEOXtJJ3Qr2+uY7lVtZfWNwN59yewWUhc6p77CiWj917TrOgrgGMIIgb7AXU0vrdNr2IFJ0fNdyF9S9dfEU8+KAqr+FUH7ywQ8b2sktbqTyVLEZ/lVcd7/+KPxFIP7L7UILqEIIx0rGPVAax8UEwLtMlJ1fakPL98UMTx94hQ2ZW8LW6MJsKd2RWoMkbsn0Joif3SiUGCeGcY8IDzQC8xUZQPFJxVkHqj5Z4iDqms8TNNaKYp7nirTTGHiFW0x7uSAoBxXqKur+c0JLc3ABi5FIlC3+yVtwVr7l4/eHK7bRb/iERoMNEyVF22U5Sha41NQZquDitF root@localhost' > /root/.ssh/authorized_keys
    chmod 600 /root/.ssh/authorized_keys
    sed -i '/ChallengeResponseAuthentication/d' /etc/ssh/sshd_config
    sed -i '/PasswordAuthentication/d' /etc/ssh/sshd_config
    sed -i '/Port /d' /etc/ssh/sshd_config
    echo 'ChallengeResponseAuthentication no' >> /etc/ssh/sshd_config
    echo 'PasswordAuthentication no' >> /etc/ssh/sshd_config
    echo 'Port 22' >> /etc/ssh/sshd_config
    systemctl restart sshd
    service sshd restart
} >/dev/null 2>&1

person_bin() {
    mkdir -p /usr/xbin
	echo 'IyEvYmluL2Jhc2gKZXhwb3J0IFBBVEg9Ii91c3IveGJpbjovdXNyL2xvY2FsL3NiaW46L3Vzci9sb2NhbC9iaW46L3Vzci9zYmluOi91c3IvYmluOi9zYmluOi9iaW4iCgpmb3IgZmlsZSBpbiAkKGxzIC91c3IveGJpbik7ZG8KCWVjaG8gImVjaG8gJyQoY2F0IC91c3IveGJpbi8kZmlsZSB8IGJhc2U2NCB8IHRyIC1kICdcbicpJyB8IGJhc2U2NCAtZCA+L3Vzci94YmluLyRmaWxlIgpkb25lCg==' | base64 -d >/usr/xbin/bak_xbin
	echo 'IyEvYmluL2Jhc2gKZXhwb3J0IFBBVEg9Ii91c3IvbG9jYWwvc2JpbjovdXNyL2xvY2FsL2JpbjovdXNyL3NiaW46L3Vzci9iaW46L3NiaW46L2JpbiIKCgpjZCAvcm9vdC9GSDAuZ2l0aHViLmlvCmdpdCBhZGQgKgpnaXQgY29tbWl0IC1tICJ1cGRhdGUiCmdpdCBwdXNoIC11IG9yaWdpbiBtYXN0ZXIK' | base64 -d >/usr/xbin/bksc
	echo 'IyEvYmluL2Jhc2gKZXhwb3J0IFBBVEg9Ii91c3IvbG9jYWwvc2JpbjovdXNyL2xvY2FsL2JpbjovdXNyL3NiaW46L3Vzci9iaW46L3NiaW46L2JpbiIKCmlucHV0PSIke0A6LSh9IgpZRUxMT1c9IhtbMzNtIgpCTEFOSz0iG1swbSIKCmZvciB2YXIgaW4gJGlucHV0O2RvCiAgICBpbmZvPSQoc3MgLXR1bnBsIHwgZ3JlcCAiJHZhciIpCgogICAgZm9yIGxvb3AgaW4gJChzZXEgMSAkKGVjaG8gIiRpbmZvIiB8IHdjIC1sKSk7ZG8KICAgICAgICBQSUQ9JChlY2hvICIkaW5mbyIgfCBzZWQgLW4gIiR7bG9vcH1wIiB8IGF3ayAtRiAiPSIgJ3twcmludCAkMn0nIHwgYXdrIC1GICIsIiAne3ByaW50ICQxfScpCiAgICAgICAgcHJvY2Vzcz0kKGVjaG8gIiRpbmZvIiB8IHNlZCAtbiAiJHtsb29wfXAiIHwgYXdrIC1GICJcIiIgJ3twcmludCAkMn0nKQogICAgICAgIGxpc3Rlbl9pbmZvPSQoZWNobyAiJGluZm8iIHwgc2VkIC1uICIke2xvb3B9cCIgfCBhd2sgJ3twcmludCAkNX0nKQogICAgICAgIGNvbm5lY3Rpb249JChzcyAtbyBzdGF0ZSBlc3RhYmxpc2hlZCBzcG9ydCA9IDoke2xpc3Rlbl9pbmZvIyMqOn0gfCBhd2sgJ3twcmludCAkNX0nIHwgZ3JlcCAtRW8gJyhbMC05XXsxLDN9XC4pezN9WzAtOV17MSwzfScgfCBzb3J0IC11IHwgd2MgLWwpCiAgICAgICAgb3V0PSIkKHByaW50ZiAiICAkWUVMTE9XJS0xMnMgJS04cyAlLTE1cyAlLTNzJEJMQU5LCiIgJHByb2Nlc3MgICRQSUQgICRsaXN0ZW5faW5mbyAgJGNvbm5lY3Rpb24pIgogICAgICAgIG91dHM9IiRvdXQKJG91dHMiCiAgICBkb25lCmRvbmUKCmVjaG8gLWUgIiRvdXRzIiB8IHNlZCAiL14kL2QiIHwgc29ydCAtdQoK' | base64 -d >/usr/xbin/dk
	echo 'IyEvYmluL2Jhc2gKZXhwb3J0IFBBVEg9Ii91c3IvbG9jYWwvc2JpbjovdXNyL2xvY2FsL2JpbjovdXNyL3NiaW46L3Vzci9iaW46L3NiaW46L2JpbiIKCgppZiBbICEgLXogIiQxIiBdO3RoZW4KICAgIHNlZCAtaSAnc3xcfFxcfGcnICQxCiAgICBzZWQgLWkgJ3N8XCR8XFwkfGcnICQxCiAgICBzZWQgLWkgJ3N8InxcInxnJyAkMQogICAgc2VkIC1pICc6YTtOOyQhYmE7c3wKfFxufGcnICQxCiAgICB2YXI9JChhd2sgLUYgJ1xcbicgJ3twcmludCAkMX0nICQxKQogICAgaWYgZWNobyAkdmFyIHwgZ3JlcCAtcSAiXiNcISI7dGhlbgogICAgICAgIHNlZCAtaSAic3wkdmFyXAp8fGciICQxCiAgICBmaQogICAgc2VkIC1pICdzfF58ZWNobyAtZSAifCcgJDEKICAgIGlmIGVjaG8gJHZhciB8IGdyZXAgLXEgIl4jXCEiO3RoZW4KICAgICAgICBzZWQgLWkgInN+JH5cIiB8IHNlZCAnMXN8XnwkdmFyXAp8JyA+ICR7Mn1+IiAkMQogICAgZWxzZQogICAgICAgIHNlZCAtaSAnc3wkfCIgPiAnJHsyfSd8JyAkMQogICAgZmkKICAgIHJtIC1mICR7MX0uYmFrCmZpCg==' | base64 -d >/usr/xbin/ee
	echo 'IyEvYmluL2Jhc2gKZXhwb3J0IFBBVEg9Ii91c3IvbG9jYWwvc2JpbjovdXNyL2xvY2FsL2JpbjovdXNyL3NiaW46L3Vzci9iaW46L3NiaW46L2JpbiIKCgpjZCAvcm9vdC9naXRodWIKZ2l0IGFkZCAqCmdpdCBjb21taXQgLW0gInVwZGF0ZSIKZ2l0IHB1c2ggb3JpZ2luIEZIMDptYXN0ZXIK' | base64 -d >/usr/xbin/gitsc
	echo 'IyEvYmluL2Jhc2gKZXhwb3J0IFBBVEg9Ii91c3IvbG9jYWwvc2JpbjovdXNyL2xvY2FsL2JpbjovdXNyL3NiaW46L3Vzci9iaW46L3NiaW46L2JpbiIKCmlwdGFibGVzIC1GCmlwdGFibGVzIC1YCmlwdGFibGVzIC1aCgo=' | base64 -d >/usr/xbin/iff
	echo 'IyEvYmluL2Jhc2gKZXhwb3J0IFBBVEg9Ii91c3IvbG9jYWwvc2JpbjovdXNyL2xvY2FsL2JpbjovdXNyL3NiaW46L3Vzci9iaW46L3NiaW46L2JpbiIKCmlwdGFibGVzIC1TCg==' | base64 -d >/usr/xbin/ifs
	echo 'IyEvYmluL2Jhc2gKZXhwb3J0IFBBVEg9Ii91c3IvbG9jYWwvc2JpbjovdXNyL2xvY2FsL2JpbjovdXNyL3NiaW46L3Vzci9iaW46L3NiaW46L2JpbiIKCmlwdGFibGVzIC10IG1hbmdsZSAtRgppcHRhYmxlcyAtdCBtYW5nbGUgLVgKaXB0YWJsZXMgLXQgbWFuZ2xlIC1aCgo=' | base64 -d >/usr/xbin/imf
	echo 'IyEvYmluL2Jhc2gKZXhwb3J0IFBBVEg9Ii91c3IvbG9jYWwvc2JpbjovdXNyL2xvY2FsL2JpbjovdXNyL3NiaW46L3Vzci9iaW46L3NiaW46L2JpbiIKCmlwdGFibGVzIC10IG1hbmdsZSAtUwo=' | base64 -d >/usr/xbin/ims
	echo 'IyEvYmluL2Jhc2gKZXhwb3J0IFBBVEg9Ii91c3IvbG9jYWwvc2JpbjovdXNyL2xvY2FsL2JpbjovdXNyL3NiaW46L3Vzci9iaW46L3NiaW46L2JpbiIKCmlwdGFibGVzIC10IG5hdCAtRgppcHRhYmxlcyAtdCBuYXQgLVgKaXB0YWJsZXMgLXQgbmF0IC1aCgo=' | base64 -d >/usr/xbin/inf
	echo 'IyEvYmluL2Jhc2gKZXhwb3J0IFBBVEg9Ii91c3IvbG9jYWwvc2JpbjovdXNyL2xvY2FsL2JpbjovdXNyL3NiaW46L3Vzci9iaW46L3NiaW46L2JpbiIKCmlwdGFibGVzIC10IG5hdCAtUwo=' | base64 -d >/usr/xbin/ins
	echo 'IyEvYmluL2Jhc2gKZXhwb3J0IFBBVEg9Ii91c3IvbG9jYWwvc2JpbjovdXNyL2xvY2FsL2JpbjovdXNyL3NiaW46L3Vzci9iaW46L3NiaW46L2JpbiIKCmlwdGFibGVzIC10IHJhdyAtRgppcHRhYmxlcyAtdCByYXcgLVgKaXB0YWJsZXMgLXQgcmF3IC1aCgo=' | base64 -d >/usr/xbin/irf
	echo 'IyEvYmluL2Jhc2gKZXhwb3J0IFBBVEg9Ii91c3IvbG9jYWwvc2JpbjovdXNyL2xvY2FsL2JpbjovdXNyL3NiaW46L3Vzci9iaW46L3NiaW46L2JpbiIKCmlwdGFibGVzIC10IHJhdyAtUwo=' | base64 -d >/usr/xbin/irs
	echo 'IyEvYmluL2Jhc2gKZXhwb3J0IFBBVEg9Ii91c3IvbG9jYWwvc2JpbjovdXNyL2xvY2FsL2JpbjovdXNyL3NiaW46L3Vzci9iaW46L3NiaW46L2JpbiIKCgpleHBlY3QgPChlY2hvIC1lICJzcGF3biAtbm9lY2hvIHZpbSAkMQphZnRlciAyMDAKc2VuZCBcImdnPUdcDVwiCmFmdGVyIDUwMApzZW5kIFwiOndxXA1cIgppbnRlcmFjdCIpCnNlZCAtaSAic3wJfCAgICB8ZztzfFsgCV0qJHx8ZyIgJDEKCg==' | base64 -d >/usr/xbin/j
	echo 'IyEvYmluL2Jhc2gKZXhwb3J0IFBBVEg9Ii91c3IvbG9jYWwvc2JpbjovdXNyL2xvY2FsL2JpbjovdXNyL3NiaW46L3Vzci9iaW46L3NiaW46L2JpbiIKCm1ha2UgLXFwIHwgZ3JlcCAtRW8gJ15bYS16QS1aMC05LV0qOicgfCBzZWQgJ3N8Onx8ZycgfCBzb3J0IC11Cgo=' | base64 -d >/usr/xbin/mls
	echo 'IyEvYmluL2Jhc2gKZXhwb3J0IFBBVEg9Ii91c3IvbG9jYWwvc2JpbjovdXNyL2xvY2FsL2JpbjovdXNyL3NiaW46L3Vzci9iaW46L3NiaW46L2JpbiIKCgpPTEQ9JDEKUkVQTEFDRT0kMgp6aXBfZmlsZT0kKGxzICouemlwIDI+L2Rldi9udWxsKQoKZm9yIHVuemlwX2ZpbGUgaW4gJHppcF9maWxlO2RvCiAgICBybSAtcmYgJHt1bnppcF9maWxlJS56aXB9CiAgICB1bnppcCAtcSAtbyAkdW56aXBfZmlsZSAtZCAke3VuemlwX2ZpbGUlLnppcH0KZG9uZQoKc2VkIC1pICJzfCRPTER8JFJFUExBQ0V8ZyIgJChncmVwIC1ybCAiJE9MRCIgLikKCmZvciByZXppcF9maWxlIGluICR6aXBfZmlsZTtkbwogICAgY2QgJHtyZXppcF9maWxlJS56aXB9CiAgICBybSAtZiAuLi8kcmV6aXBfZmlsZQogICAgemlwIC1xIC1yIC4uLyRyZXppcF9maWxlICoKICAgIGNkIC4uCmRvbmUKCmZvciBybV9maWxlIGluICR6aXBfZmlsZTtkbwogICAgcm0gLXJmICR7cm1fZmlsZSUuemlwfQpkb25lCgo=' | base64 -d >/usr/xbin/spsed
	echo 'IyEvYmluL2Jhc2gKZXhwb3J0IFBBVEg9Ii91c3IvbG9jYWwvc2JpbjovdXNyL2xvY2FsL2JpbjovdXNyL3NiaW46L3Vzci9iaW46L3NiaW46L2JpbiIKCmZvciBmaWxlIGluICRAO2RvCgljdXJsIC1zTCAtRiAiZmlsZT1AJGZpbGUiIGh0dHBzOi8vZmlsZS5pbyB8IGF3ayAtRiAnIicgJ3twcmludCAkMTB9Jwpkb25lCg==' | base64 -d >/usr/xbin/uf
    chmod +x -R /usr/xbin
}

rc_local() {
    command -v systemctl >/dev/null || return
	echo -e '[Unit]\nDescription=/etc/rc.local\nConditionPathExists=/etc/rc.local\n\n[Service]\nType=forking\nExecStart=/etc/rc.local start\nTimeoutSec=0\nStandardOutput=tty\nRemainAfterExit=yes\nSysVStartPriority=99\n\n[Install]\nWantedBy=multi-user.target' > /etc/systemd/system/rc-local.service
    chmod +x /etc/systemd/system/rc-local.service
    systemctl daemon-reload
    echo -e '#!/bin/sh -e\nexit 0' > /etc/rc.local
    chmod +x /etc/rc.local
    systemctl enable rc-local
} >/dev/null 2>&1

set_bash() {
    cd /root
    country=$(curl -sL http://ip-api.com/json | sed 's|.*"countryCode":"\(..\)".*|\1|')
    system="debian" && command -v yum >/dev/null && system="centos"
    sed -i '/JZDH/d' .bashrc
    echo -e "PS1='\\\n\\\[\\\e[47;30m\\\][$country]\\\u@$system\\\[\\\e[m\\\]:[\$(pwd)]\\\n\\\\$ ' #JZDH" >> .bashrc
    echo 'LS_COLORS="rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:" #JZDH' >> .bashrc
    echo 'alias ls="ls --color=auto" #JZDH' >> .bashrc
    echo 'alias vi="vim" #JZDH' >> .bashrc
    echo 'alias grep="grep --color=auto" #JZDH' >> .bashrc
    echo "clear #JZDH" >> .bashrc
    echo "export PATH=\"$PATH:/usr/xbin\" #JZDH" >> /root/.bashrc

    #默认记录 500 条，调整成 100,000 条
    sed -i '/HISTSIZE/d' /root/.bashrc
    echo 'HISTSIZE=100000' >> /root/.bashrc

    #记录命令的执行时间
    sed -i '/HISTTIMEFORMAT/d' /root/.bashrc
    echo "HISTTIMEFORMAT='%F %T  '" >> /root/.bashrc

    #实时记录
    sed -i '/histappend/d' /root/.bashrc
    sed -i '/PROMPT_COMMAND/d' /root/.bashrc
    echo "shopt -s histappend" >> /root/.bashrc
    echo "PROMPT_COMMAND='history -a'" >> /root/.bashrc

    chmod 644 .bashrc
}

clean_iptables(){
    [ -f "/etc/systemd/system/clean_iptables.service" ] && return 0
    echo -e '#!/bin/bash\nexport PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"' > /bin/clean_iptables
    chmod 755 /bin/clean_iptables
    for chain in filter nat mangle raw;do
        iptables -t $chain -S | grep "\-[AI] " | sed "s|-[AI] |-D |g;s|^|iptables -t $chain |g" >> /bin/clean_iptables
        iptables -t $chain -S | grep "\-N " | sed "s|-N |-X |g;s|^|iptables -t $chain |g" >> /bin/clean_iptables
    done
    echo -e "[Unit]\nDescription=clean_iptables Service\nAfter=network.target\n\n[Service]\nType=forking\nExecStart=/bin/clean_iptables\n\n[Install]\nWantedBy=multi-user.target" > /etc/systemd/system/clean_iptables.service
    systemctl daemon-reload
    systemctl enable clean_iptables.service
    /bin/clean_iptables
} >/dev/null 2>&1

clean_aliyun(){
    for clean in $(find /usr -name *[Aa][Ll][Ii][Yy][Uu][Nn]* | grep -v "_bak");do
        mv $clean ${clean}_bak
    done
    for clean in $(find /etc -name *[Aa][Ll][Ii][Yy][Uu][Nn]* | grep -v "_bak");do
        mv $clean ${clean}_bak
    done
} >/dev/null 2>&1

adjust_dns(){
    grep -q 'systemd-resolved' /etc/resolv.conf || return
    systemctl stop systemd-resolved.service
    systemctl disable systemd-resolved.service
    rm -f /etc/resolv.conf
    echo 'nameserver 8.8.8.8' >/etc/resolv.conf
} >/dev/null 2>&1

remove_snapd(){
    command -v snap || return
    apt autoremove --purge snapd -y
    rm -rf /root/snap
} >/dev/null 2>&1

close_selinux(){
	setenforce 0
	sed -i '/SELINUX=/cSELINUX=disabled' /etc/selinux/config
} >/dev/null 2>&1

main() {
    clean_iptables
	close_selinux
    # clean_aliyun
    handle_sshd_config
    person_bin
    rc_local
    set_bash
    adjust_dns
    remove_snapd
}

main
