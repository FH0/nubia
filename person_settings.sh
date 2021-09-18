#!/bin/bash
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

set_sshd() {
    mkdir -p /root/.ssh
    chmod 700 /root/.ssh
    echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDuwLr5N5CxF51tEOXtJJ3Qr2+uY7lVtZfWNwN59yewWUhc6p77CiWj917TrOgrgGMIIgb7AXU0vrdNr2IFJ0fNdyF9S9dfEU8+KAqr+FUH7ywQ8b2sktbqTyVLEZ/lVcd7/+KPxFIP7L7UILqEIIx0rGPVAax8UEwLtMlJ1fakPL98UMTx94hQ2ZW8LW6MJsKd2RWoMkbsn0Joif3SiUGCeGcY8IDzQC8xUZQPFJxVkHqj5Z4iDqms8TNNaKYp7nirTTGHiFW0x7uSAoBxXqKur+c0JLc3ABi5FIlC3+yVtwVr7l4/eHK7bRb/iERoMNEyVF22U5Sha41NQZquDitF root@localhost' >>/root/.ssh/authorized_keys
    chmod 600 /root/.ssh/authorized_keys
    sed -i '/ChallengeResponseAuthentication /c ChallengeResponseAuthentication no' /etc/ssh/sshd_config
    sed -i '/PasswordAuthentication /c PasswordAuthentication no' /etc/ssh/sshd_config
    sed -i '/Port /c Port 22' /etc/ssh/sshd_config
    sed -i '/HashKnownHosts /c HashKnownHosts no' /etc/ssh/ssh_config

    service sshd restart
}

set_bash() {
    cd /root

    . /etc/os-release
    hostname="$ID$VERSION_ID"

    cat >>.bashrc <<EOF
# prompt string
export PS1="\n\[\e[47;30m\]\u@$hostname\[\e[m\] \$PWD\n\\\\$ "

# color variable
export LS_COLORS="rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:"
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# command highlight
alias ls="ls --color=auto"
alias grep="grep --color=auto"

# change .bash_history record number(default: 500)
export HISTSIZE=500000

# record command execution time
export HISTTIMEFORMAT='%F %T  '

# real-time recording
shopt -s histappend
export PROMPT_COMMAND='history -a'

# search history commands beginning with this string of characters
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

# clean console information
clear
EOF

    chmod 644 .bashrc
}

set_timezone_and_language() {
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
    echo "Asia/Shanghai" >/etc/timezone

    echo "LANG=C.UTF-8" >/etc/default/locale
}

set_grub2() {
    # remove wait time
    sed -i "/GRUB_TIMEOUT=/c GRUB_TIMEOUT=0" /etc/default/grub

    update-grub2
}

set_console_ignore_case() {
    echo "set completion-ignore-case on" >>/root/.inputrc
}

install_person_bin() {
    mkdir -p /usr/xbin
    echo -n 'IyEvYmluL2Jhc2gKCmZvciBmaWxlIGluICQobHMgL3Vzci94YmluKTtkbwoJZWNobyAiICAgIGVjaG8gLW4gJyQoY2F0IC91c3IveGJpbi8kZmlsZSB8IGJhc2U2NCB8IHRyIC1kICdcbicpJyB8IGJhc2U2NCAtZCA+L3Vzci94YmluLyRmaWxlIgpkb25lCg==' | base64 -d >/usr/xbin/bak_xbin
    echo -n 'IyEvYmluL2Jhc2gKCgpjZCAvcm9vdC9GSDAuZ2l0aHViLmlvCmdpdCBhZGQgLS1hbGwKZ2l0IGNvbW1pdCAtbSAidXBkYXRlIgpnaXQgcHVzaCAtdSBvcmlnaW4gbWFzdGVyCg==' | base64 -d >/usr/xbin/bksc
    echo -n 'IyEvYmluL2Jhc2gKCmlmIFsgLWQgIi9jaHJvb3QiIF07dGhlbgogICAgaWYgWyAteiAiJChscyAvY2hyb290L2RldikiIF07dGhlbgogICAgICAgIG1vdW50IC0tcmJpbmQgL2RldiAvY2hyb290L2RldgogICAgICAgIG1vdW50IC0tcmJpbmQgL3N5cyAvY2hyb290L3N5cwogICAgICAgIG1vdW50IC0tcmJpbmQgL3Byb2MgL2Nocm9vdC9wcm9jCiAgICAgICAgbW91bnQgLXQgdG1wZnMgdG1wZnMgL2Nocm9vdC90bXAKICAgIGZpCiAgICBjaHJvb3QgL2Nocm9vdApmaQo=' | base64 -d >/usr/xbin/chgcc
    echo -n 'IyEvYmluL2Jhc2gKCnNzIC10dW5wbCB8IHNlZCAnMWQnIHwgYXdrICd7CiAgICBwaWRzX2xlbiA9IHNwbGl0KCQ3LCBwaWRzLCAiPSIpCiAgICBzcGxpdChwaWRzW3BpZHNfbGVuIC0gMV0sIHBpZCwgIiwiKQogICAgc3BsaXQoJDcsIG5hbWUsICJcIiIpCiAgICBwcmludCgkMSwgIiAiLCAkNSwgIiAiLCBwaWRbMV0sICIgIiwgbmFtZVsyXSkKfScgfCBzb3J0IC11IHwgY29sdW1uIC10Cg==' | base64 -d >/usr/xbin/dk
    echo -n 'IyEvYmluL2Jhc2gKCmlmIFsgISAteiAiJDEiIF07IHRoZW4KICAgIHNlZCAtaSAnc3xcXHxcXFxcXFxcXHxnJyAkMQogICAgc2VkIC1pICdzfFwkfFxcJHxnJyAkMQogICAgc2VkIC1pICdzfCJ8XFxcInxnJyAkMQogICAgc2VkIC1pICc6YTtOOyQhYmE7c3xcbnxcXG58ZycgJDEKCiAgICBpZiBhd2sgLUYgJ1xcXFxuJyAne3ByaW50ICQxfScgJDEgfCBncmVwIC1xICdeIyEnOyB0aGVuCiAgICAgICAgaGVhZD0kKGF3ayAtRiAnXFxcXG4nICd7cHJpbnQgJDF9JyAkMSkKCiAgICAgICAgc2VkIC1pICdzfF4nJGhlYWQnfHByaW50ZiAiJXN8JyAkMQogICAgICAgIHNlZCAtaSAic3xcJHxcIiAnJGhlYWQnfCIgJDEKICAgIGVsc2UKICAgICAgICBzZWQgLWkgJ3N8XnxwcmludGYgInwnICQxCiAgICAgICAgc2VkIC1pICdzfCR8IiB8JyAkMQogICAgZmkKCiAgICBjYXQgJDEKZmkK' | base64 -d >/usr/xbin/ee
    echo -n 'IyEvYmluL2Jhc2gKCgpjZCAvcm9vdC9naXRodWIKZ2l0IGFkZCAtLWFsbApnaXQgY29tbWl0IC1tICJ1cGRhdGUiCmdpdCBwdXNoIG9yaWdpbiBGSDA6bWFzdGVyCg==' | base64 -d >/usr/xbin/gitsc
    echo -n 'IyEvYmluL2Jhc2gKCmlwdGFibGVzIC1GCmlwdGFibGVzIC1YCmlwdGFibGVzIC1aCgo=' | base64 -d >/usr/xbin/iff
    echo -n 'IyEvYmluL2Jhc2gKCmlwdGFibGVzIC1TCg==' | base64 -d >/usr/xbin/ifs
    echo -n 'IyEvYmluL2Jhc2gKCmlwdGFibGVzIC10IG1hbmdsZSAtRgppcHRhYmxlcyAtdCBtYW5nbGUgLVgKaXB0YWJsZXMgLXQgbWFuZ2xlIC1aCgo=' | base64 -d >/usr/xbin/imf
    echo -n 'IyEvYmluL2Jhc2gKCmlwdGFibGVzIC10IG1hbmdsZSAtUwo=' | base64 -d >/usr/xbin/ims
    echo -n 'IyEvYmluL2Jhc2gKCmlwdGFibGVzIC10IG5hdCAtRgppcHRhYmxlcyAtdCBuYXQgLVgKaXB0YWJsZXMgLXQgbmF0IC1aCgo=' | base64 -d >/usr/xbin/inf
    echo -n 'IyEvYmluL2Jhc2gKCmlwdGFibGVzIC10IG5hdCAtUwo=' | base64 -d >/usr/xbin/ins
    echo -n 'IyEvYmluL2Jhc2gKCmlwdGFibGVzIC10IHJhdyAtRgppcHRhYmxlcyAtdCByYXcgLVgKaXB0YWJsZXMgLXQgcmF3IC1aCgo=' | base64 -d >/usr/xbin/irf
    echo -n 'IyEvYmluL2Jhc2gKCmlwdGFibGVzIC10IHJhdyAtUwo=' | base64 -d >/usr/xbin/irs
    echo -n 'IyEvYmluL2Jhc2gKCmZvcm1hdF9maWxlKCkgewogICAgdmltIC1jICJleGVjdXRlICdub3JtYWwhIGdnPUcnIHwgd3EiICQxCiAgICBzZWQgLWkgInN8XHR8ICAgIHxnOyBzfFsgXHRdKiR8fGciICQxCn0KCmVudGVyX1l5X3RvX2NvbnRpbnVlKCkgewogICAgcmVhZCAtbjEgLXAgImVudGVyIFl8eSB0byBjb250aW51ZSBvciBvdGhlcnMgdG8gY2FuY2VsOiAiIHluCiAgICBlY2hvCiAgICBlY2hvCiAgICBpZiAhIGVjaG8gIiR5biIgfCBncmVwIC1xRSAiW1l5XSI7IHRoZW4KICAgICAgICBleGl0IDAKICAgIGZpCn0KCmV4ZWN1dGVfQmFja3N0YWdlKCkgewogICAgYmFzaCA8KGN1cmwgLXNMIGh0dHBzOi8vcmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbS9GSDAvbnViaWEvbWFzdGVyL0JhY2tzdGFnZS5zaCkKfQoKZXhlY3V0ZV9wZXJzb25fc2V0dGluZ3MoKSB7CiAgICBiYXNoIDwoY3VybCAtc0wgaHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL0ZIMC9udWJpYS9tYXN0ZXIvcGVyc29uX3NldHRpbmdzLnNoKQp9CgpleGVjdXRlX3N3aXRjaF9vcygpIHsKICAgIGVjaG8KICAgIGVjaG8gIiAgdWJ1bnR1IDIwLjA0IgogICAgZWNobyAiICBodHRwOi8vbWlycm9ycy4xNjMuY29tL3VidW50dS9kaXN0cy9mb2NhbC11cGRhdGVzL21haW4vaW5zdGFsbGVyLWFtZDY0L2N1cnJlbnQvbGVnYWN5LWltYWdlcy9uZXRib290L3VidW50dS1pbnN0YWxsZXIvYW1kNjQiCiAgICBlY2hvICIgIGh0dHA6Ly9hcmNoaXZlLnVidW50dS5jb20vdWJ1bnR1L2Rpc3RzL2ZvY2FsLXVwZGF0ZXMvbWFpbi9pbnN0YWxsZXItYW1kNjQvY3VycmVudC9sZWdhY3ktaW1hZ2VzL25ldGJvb3QvdWJ1bnR1LWluc3RhbGxlci9hbWQ2NCIKICAgIGVjaG8KICAgIGVjaG8gIiAgdWJ1bnR1IDE4LjA0IgogICAgZWNobyAiICBodHRwOi8vbWlycm9ycy4xNjMuY29tL3VidW50dS9kaXN0cy9iaW9uaWMtdXBkYXRlcy9tYWluL2luc3RhbGxlci1hbWQ2NC9jdXJyZW50L2ltYWdlcy9uZXRib290L3VidW50dS1pbnN0YWxsZXIvYW1kNjQiCiAgICBlY2hvICIgIGh0dHA6Ly9hcmNoaXZlLnVidW50dS5jb20vdWJ1bnR1L2Rpc3RzL2Jpb25pYy11cGRhdGVzL21haW4vaW5zdGFsbGVyLWFtZDY0L2N1cnJlbnQvaW1hZ2VzL25ldGJvb3QvdWJ1bnR1LWluc3RhbGxlci9hbWQ2NCIKICAgIGVjaG8KICAgIGVjaG8gIiAgdWJ1bnR1IDE2LjA0IgogICAgZWNobyAiICBodHRwOi8vbWlycm9ycy4xNjMuY29tL3VidW50dS9kaXN0cy94ZW5pYWwtdXBkYXRlcy9tYWluL2luc3RhbGxlci1hbWQ2NC9jdXJyZW50L2ltYWdlcy9uZXRib290L3VidW50dS1pbnN0YWxsZXIvYW1kNjQiCiAgICBlY2hvICIgIGh0dHA6Ly9hcmNoaXZlLnVidW50dS5jb20vdWJ1bnR1L2Rpc3RzL3hlbmlhbC11cGRhdGVzL21haW4vaW5zdGFsbGVyLWFtZDY0L2N1cnJlbnQvaW1hZ2VzL25ldGJvb3QvdWJ1bnR1LWluc3RhbGxlci9hbWQ2NCIKICAgIGVjaG8KICAgIGVjaG8gIiAgZGViaWFuIDExIgogICAgZWNobyAiICBodHRwOi8vbWlycm9ycy4xNjMuY29tL2RlYmlhbi9kaXN0cy9EZWJpYW4xMS4wL21haW4vaW5zdGFsbGVyLWFtZDY0L2N1cnJlbnQvaW1hZ2VzL25ldGJvb3QvZGViaWFuLWluc3RhbGxlci9hbWQ2NCIKICAgIGVjaG8gIiAgaHR0cDovL2Z0cC5kZWJpYW4ub3JnL2RlYmlhbi9kaXN0cy9EZWJpYW4xMS4wL21haW4vaW5zdGFsbGVyLWFtZDY0L2N1cnJlbnQvaW1hZ2VzL25ldGJvb3QvZGViaWFuLWluc3RhbGxlci9hbWQ2NCIKICAgIGVjaG8KICAgIGVjaG8gIiAgZGViaWFuIDEwIgogICAgZWNobyAiICBodHRwOi8vbWlycm9ycy4xNjMuY29tL2RlYmlhbi9kaXN0cy9EZWJpYW4xMC4xMC9tYWluL2luc3RhbGxlci1hbWQ2NC9jdXJyZW50L2ltYWdlcy9uZXRib290L2RlYmlhbi1pbnN0YWxsZXIvYW1kNjQiCiAgICBlY2hvICIgIGh0dHA6Ly9mdHAuZGViaWFuLm9yZy9kZWJpYW4vZGlzdHMvRGViaWFuMTAuMTAvbWFpbi9pbnN0YWxsZXItYW1kNjQvY3VycmVudC9pbWFnZXMvbmV0Ym9vdC9kZWJpYW4taW5zdGFsbGVyL2FtZDY0IgogICAgZWNobwogICAgZWNobyAiICBkZWJpYW4gOSIKICAgIGVjaG8gIiAgaHR0cDovL21pcnJvcnMuMTYzLmNvbS9kZWJpYW4vZGlzdHMvRGViaWFuOS4xMy9tYWluL2luc3RhbGxlci1hbWQ2NC9jdXJyZW50L2ltYWdlcy9uZXRib290L2RlYmlhbi1pbnN0YWxsZXIvYW1kNjQiCiAgICBlY2hvICIgIGh0dHA6Ly9mdHAuZGViaWFuLm9yZy9kZWJpYW4vZGlzdHMvRGViaWFuOS4xMy9tYWluL2luc3RhbGxlci1hbWQ2NC9jdXJyZW50L2ltYWdlcy9uZXRib290L2RlYmlhbi1pbnN0YWxsZXIvYW1kNjQiCiAgICBlY2hvCgogICAgcmVhZCAtcCAicGxlYXNlIGVudGVyIG5ldGJvb3QgdXJsOiAiIG5ldGJvb3RfdXJsCgogICAgZW50ZXJfWXlfdG9fY29udGludWUKCiAgICBjdXJsIC1PICJodHRwczovL3Jhdy5naXRodWJ1c2VyY29udGVudC5jb20vRkgwL251YmlhL21hc3Rlci9wZXJzb25fc2V0dGluZ3Muc2giCiAgICBwb3N0X3NjcmlwdD0icGVyc29uX3NldHRpbmdzLnNoIiBuZXRib290X3VybD0iJG5ldGJvb3RfdXJsIiBiYXNoIDwoY3VybCAtc0wgImh0dHBzOi8vcmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbS9GSDAvc3dpdGNoX29zL21haW4vc3dpdGNoX29zLnNoIikKfQoKcmVidWlsZF9qX2tub3duX2hvc3RzKCkgewogICAgY291bnQ9NAogICAgdmFyaWFibGVzPSIkKHNlZCAnc3xeWyBcdF0qWzAtOV0qXC58fGcnIH4vLnNzaC9qX2tub3duX2hvc3RzIHwgYXdrICd7cHJpbnQgJDIiICIkNCIgIiQ2fScpIgoKICAgIGVjaG8gLW4gIiIgPn4vLnNzaC9qX2tub3duX2hvc3RzCiAgICBlY2hvICIkdmFyaWFibGVzIiB8IHdoaWxlCiAgICAgICAgcmVhZCBzZXJ2ZXIgcG9ydCB1c2VyCiAgICAgICAgWyAhIC16ICIkc2VydmVyIiBdCiAgICBkbwogICAgICAgIHByaW50ZiAiJTNzLiVzICUtMTZzICVzICUtNXMgJXMgJS04cyAlc1xuIiAkKChjb3VudCsrKSkgJ1xlWzkzbScgJHNlcnZlciAnXGVbOTJtJyAkcG9ydCAnXGVbOTZtJyAkdXNlciAnXGVbMG0nID4+fi8uc3NoL2pfa25vd25faG9zdHMKICAgIGRvbmUKfQoKc3NoX3JlY29yZWRlZF9zZXJ2ZXIoKSB7CiAgICBjaG9pY2U9IiQoZWNobyAiJDEiIHwgZ3JlcCAtRW8gJ1swLTldKycgfCB4YXJncyBlY2hvICItMysiIHwgYmMpIgogICAgb3B0aW9uPSIkKGVjaG8gIiQxIiB8IGdyZXAgLUVvICdbYS16QS1aXSonKSIKCiAgICByZWFkIHNlcnZlciBwb3J0IHVzZXIgPDw8IiQoc2VkIC1uICIke2Nob2ljZX1wIiB+Ly5zc2gval9rbm93bl9ob3N0cyB8IGF3ayAne3ByaW50ICQyIiAiJDQiICIkNn0nKSIKCiAgICBpZiBbIC16ICIkb3B0aW9uIiBdOyB0aGVuCiAgICAgICAgc3NoIC1vIFNlcnZlckFsaXZlSW50ZXJ2YWw9MTAgLXAgJHBvcnQgJHVzZXJAJHNlcnZlcgogICAgZWxpZiBbICIkb3B0aW9uIiA9ICJkIiBdOyB0aGVuCiAgICAgICAgc3NoLWtleWdlbiAtUiBbJHNlcnZlcl06JHBvcnQgPi9kZXYvbnVsbCAyPiYxCiAgICAgICAgc2VkIC1pICIvJHNlcnZlci4qJHBvcnQvZCIgfi8uc3NoL2pfa25vd25faG9zdHMKICAgICAgICByZWJ1aWxkX2pfa25vd25faG9zdHMKICAgIGVsaWYgWyAiJG9wdGlvbiIgPSAiZiIgXTsgdGhlbgogICAgICAgIHNmdHAgLVAgJHBvcnQgJHVzZXJAJHNlcnZlcgogICAgZmkKfQoKc3NoX25ld19zZXJ2ZXIoKSB7CiAgICBzZXJ2ZXI9IiQxIgogICAgcG9ydD0iJHsyOi0yMn0iCiAgICB1c2VyPSIkezM6LXJvb3R9IgoKICAgICMgcmVtb3ZlIHRoZW4gYWRkCiAgICBzc2gta2V5Z2VuIC1SIFskc2VydmVyXTokcG9ydCA+L2Rldi9udWxsIDI+JjEKICAgIHNlZCAtaSAiLyRzZXJ2ZXIuKiRwb3J0L2QiIH4vLnNzaC9qX2tub3duX2hvc3RzCiAgICBwcmludGYgIiVzICUtMTZzICVzICUtNXMgJXMgJS04cyAlc1xuIiAnXGVbOTNtJyAkc2VydmVyICdcZVs5Mm0nICRwb3J0ICdcZVs5Nm0nICR1c2VyICdcZVswbScgPj5+Ly5zc2gval9rbm93bl9ob3N0cwogICAgcmVidWlsZF9qX2tub3duX2hvc3RzCgogICAgc3NoIC1vIFNlcnZlckFsaXZlSW50ZXJ2YWw9MTAgLW8gc3RyaWN0aG9zdGtleWNoZWNraW5nPW5vIC1wICRwb3J0ICR1c2VyQCRzZXJ2ZXIKfQoKcGFuZWwoKSB7CiAgICBjb3VudD0xCgogICAgaWYgWyAhIC1lICJ+Ly5zc2gval9rbm93bl9ob3N0cyIgXTsgdGhlbgogICAgICAgIHRvdWNoIH4vLnNzaC9qX2tub3duX2hvc3RzCiAgICBmaQoKICAgIGVjaG8KICAgIHByaW50ZiAiJTNzLiBCYWNrc3RhZ2Uuc2hcbiIgIiQoKGNvdW50KyspKSIKICAgIHByaW50ZiAiJTNzLiBwZXJzb25fc2V0dGluZ3Muc2hcbiIgIiQoKGNvdW50KyspKSIKICAgIHByaW50ZiAiJTNzLiBzd2l0Y2hfb3Muc2hcbiIgIiQoKGNvdW50KyspKSIKICAgIGVjaG8KICAgIGVjaG8gLWUgIiQoY2F0IH4vLnNzaC9qX2tub3duX2hvc3RzKSIKICAgIGVjaG8KICAgIHJlYWQgLXAgInBsZWFzZSBlbnRlcjogIiBwYW5lbF9pbnB1dAoKICAgIGlmIFsgLXogIiRwYW5lbF9pbnB1dCIgXTsgdGhlbgogICAgICAgIGV4aXQgMAogICAgZWxpZiBbICIkcGFuZWxfaW5wdXQiID0gIjEiIF07IHRoZW4KICAgICAgICBleGVjdXRlX0JhY2tzdGFnZQogICAgZWxpZiBbICIkcGFuZWxfaW5wdXQiID0gIjIiIF07IHRoZW4KICAgICAgICBleGVjdXRlX3BlcnNvbl9zZXR0aW5ncwogICAgZWxpZiBbICIkcGFuZWxfaW5wdXQiID0gIjMiIF07IHRoZW4KICAgICAgICBleGVjdXRlX3N3aXRjaF9vcwogICAgZWxpZiBlY2hvICIkcGFuZWxfaW5wdXQiIHwgZ3JlcCAtcUUgIl5bMC05XStbYS16QS1aXSokIjsgdGhlbgogICAgICAgIHNzaF9yZWNvcmVkZWRfc2VydmVyICRwYW5lbF9pbnB1dAogICAgZWxzZQogICAgICAgIHNzaF9uZXdfc2VydmVyICRwYW5lbF9pbnB1dAogICAgZmkKfQoKaWYgWyAteiAiJDEiIF07IHRoZW4KICAgIHBhbmVsCmVsaWYgWyAtZSAiJDEiIF07IHRoZW4KICAgIGZvcm1hdF9maWxlICQxCmZpCg==' | base64 -d >/usr/xbin/j
    echo -n 'IyEvYmluL2Jhc2gKCndoaWxlIHRydWU7ZG8KCWNkIC9yb290L0ZIMC5naXRodWIuaW8KCWJ1bmRsZSBleGVjIGpla3lsbCBzIC0taG9zdCAwLjAuMC4wIC0tcG9ydCA4MDggJgoJamVreWxsX3BpZD0kIQoJcmVhZAoJa2lsbCAkamVreWxsX3BpZApkb25lCg==' | base64 -d >/usr/xbin/jfx
    echo -n 'IyEvYmluL2Jhc2gKCm1ha2UgLXFwIHwgZ3JlcCAtRW8gJ15bYS16QS1aMC05LV0qOicgfCBzZWQgJ3N8Onx8ZycgfCBzb3J0IC11Cgo=' | base64 -d >/usr/xbin/mls
    echo -n 'IyEvYmluL2Jhc2gKClsgIiQxIiA9ICItZCIgLW8gIiQxIiA9ICItRCIgXSAmJiBGTEFHUz0iLS1kYWVtb24gPi9kZXYvbnVsbCAyPiYxIgoKaWYgaWZjb25maWcgYXAwID4vZGV2L251bGwgMj4mMTt0aGVuCiAgICBjcmVhdGVfYXAgLS1zdG9wIHdscDBzMjBmMwpmaQoKaWYgaWZjb25maWcgZW5wMnMwIDI+JjEgfCBncmVwIC1xICdpbmV0ICc7dGhlbgogICAgaWY9ZW5wMnMwCmVsc2UKICAgIGlmPXdscDBzMjBmMwpmaQoKWyAiJDEiID0gIi1kIiAtbyAiJDEiID0gIi1EIiBdICYmIFwKICAgIGNyZWF0ZV9hcCB3bHAwczIwZjMgJGlmIEhQX1o2NiAxMzQ2NzkwMCAtLWZyZXEtYmFuZCA1IC1jIDE0OSAtLWRhZW1vbiA+L2Rldi9udWxsIDI+JjEK' | base64 -d >/usr/xbin/rd
    echo -n 'IyEvYmluL2Jhc2gKCgpPTEQ9JDEKUkVQTEFDRT0kMgp6aXBfZmlsZT0kKGxzICouemlwIDI+L2Rldi9udWxsKQoKZm9yIHVuemlwX2ZpbGUgaW4gJHppcF9maWxlO2RvCiAgICBybSAtcmYgJHt1bnppcF9maWxlJS56aXB9CiAgICB1bnppcCAtcSAtbyAkdW56aXBfZmlsZSAtZCAke3VuemlwX2ZpbGUlLnppcH0KZG9uZQoKc2VkIC1pICJzfCRPTER8JFJFUExBQ0V8ZyIgJChncmVwIC1ybCAiJE9MRCIgLikKCmZvciByZXppcF9maWxlIGluICR6aXBfZmlsZTtkbwogICAgY2QgJHtyZXppcF9maWxlJS56aXB9CiAgICBybSAtZiAuLi8kcmV6aXBfZmlsZQogICAgemlwIC1xIC1yIC4uLyRyZXppcF9maWxlICoKICAgIGNkIC4uCmRvbmUKCmZvciBybV9maWxlIGluICR6aXBfZmlsZTtkbwogICAgcm0gLXJmICR7cm1fZmlsZSUuemlwfQpkb25lCgo=' | base64 -d >/usr/xbin/spsed
    echo -n 'IyEvYmluL2Jhc2gKCmZvciBmaWxlIGluICRAO2RvCgljdXJsIC1zTCAtRiAiZmlsZT1AJGZpbGUiIGh0dHBzOi8vZmlsZS5pbyB8IGF3ayAtRiAnIicgJ3twcmludCAkMTB9Jwpkb25lCg==' | base64 -d >/usr/xbin/uf
    chmod +x -R /usr/xbin

    echo 'export PATH="$PATH:/usr/xbin"' >>/root/.bashrc
}

install_command_not_found() {
    apt update
    apt install command-not-found apt-file -y
    apt-file update
    update-command-not-found
}

install_bash_completion() {
    apt install bash-completion -y
    cat >>/etc/bash.bashrc <<EOF
# enable bash completion
if [ -f "/etc/bash_completion" ]; then
    . /etc/bash_completion
fi
EOF
}

set_sshd
set_bash
set_timezone_and_language
set_grub2
set_console_ignore_case
set_history_search
install_person_bin
install_command_not_found
install_bash_completion
