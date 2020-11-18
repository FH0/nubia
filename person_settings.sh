#!/bin/bash
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

handle_sshd_config() {
    mkdir -p /root/.ssh
    chmod 700 /root/.ssh
    echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDuwLr5N5CxF51tEOXtJJ3Qr2+uY7lVtZfWNwN59yewWUhc6p77CiWj917TrOgrgGMIIgb7AXU0vrdNr2IFJ0fNdyF9S9dfEU8+KAqr+FUH7ywQ8b2sktbqTyVLEZ/lVcd7/+KPxFIP7L7UILqEIIx0rGPVAax8UEwLtMlJ1fakPL98UMTx94hQ2ZW8LW6MJsKd2RWoMkbsn0Joif3SiUGCeGcY8IDzQC8xUZQPFJxVkHqj5Z4iDqms8TNNaKYp7nirTTGHiFW0x7uSAoBxXqKur+c0JLc3ABi5FIlC3+yVtwVr7l4/eHK7bRb/iERoMNEyVF22U5Sha41NQZquDitF root@localhost' >/root/.ssh/authorized_keys
    chmod 600 /root/.ssh/authorized_keys
    sed -i '/ChallengeResponseAuthentication/d' /etc/ssh/sshd_config
    sed -i '/PasswordAuthentication/d' /etc/ssh/sshd_config
    sed -i '/Port /d' /etc/ssh/sshd_config
    echo 'ChallengeResponseAuthentication no' >>/etc/ssh/sshd_config
    echo 'PasswordAuthentication no' >>/etc/ssh/sshd_config
    echo 'Port 22' >>/etc/ssh/sshd_config

    #关闭 IP 混淆
    grep -q 'HashKnownHosts' /etc/ssh/ssh_config &&
        sed -i '/HashKnownHosts/c    HashKnownHosts no' /etc/ssh/ssh_config
    systemctl restart sshd
    service sshd restart
} >/dev/null 2>&1

person_bin() {
    mkdir -p /usr/xbin
    echo 'IyEvYmluL2Jhc2gKCmZvciBmaWxlIGluICQobHMgL3Vzci94YmluKTtkbwoJZWNobyAiICAgIGVjaG8gJyQoY2F0IC91c3IveGJpbi8kZmlsZSB8IGJhc2U2NCB8IHRyIC1kICdcbicpJyB8IGJhc2U2NCAtZCA+L3Vzci94YmluLyRmaWxlIgpkb25lCg==' | base64 -d >/usr/xbin/bak_xbin
    echo 'IyEvYmluL2Jhc2gKCgpjZCAvcm9vdC9GSDAuZ2l0aHViLmlvCmdpdCBhZGQgLS1hbGwKZ2l0IGNvbW1pdCAtbSAidXBkYXRlIgpnaXQgcHVzaCAtdSBvcmlnaW4gbWFzdGVyCg==' | base64 -d >/usr/xbin/bksc
    echo 'IyEvYmluL2Jhc2gKCmlmIFsgLWQgIi9jaHJvb3QiIF07dGhlbgogICAgaWYgWyAteiAiJChscyAvY2hyb290L2RldikiIF07dGhlbgogICAgICAgIG1vdW50IC0tcmJpbmQgL2RldiAvY2hyb290L2RldgogICAgICAgIG1vdW50IC0tcmJpbmQgL3N5cyAvY2hyb290L3N5cwogICAgICAgIG1vdW50IC0tcmJpbmQgL3Byb2MgL2Nocm9vdC9wcm9jCiAgICAgICAgbW91bnQgLXQgdG1wZnMgdG1wZnMgL2Nocm9vdC90bXAKICAgIGZpCiAgICBjaHJvb3QgL2Nocm9vdApmaQo=' | base64 -d >/usr/xbin/chgcc
    echo 'IyEvYmluL2Jhc2gKCmlucHV0PSIke0A6LSh9IgpZRUxMT1c9IhtbMzNtIgpCTEFOSz0iG1swbSIKCmZvciB2YXIgaW4gJGlucHV0O2RvCiAgICBpbmZvPSQoc3MgLXR1bnBsIHwgZ3JlcCAiJHZhciIpCgogICAgWyAteiAiJGluZm8iIF0gJiYgY29udGludWUKICAgIGZvciBsb29wIGluICQoc2VxIDEgJChlY2hvICIkaW5mbyIgfCB3YyAtbCkpO2RvCiAgICAgICAgUElEPSQoZWNobyAiJGluZm8iIHwgc2VkIC1uICIke2xvb3B9cCIgfCBhd2sgLUYgIj0iICd7cHJpbnQgJDJ9JyB8IGF3ayAtRiAiLCIgJ3twcmludCAkMX0nKQogICAgICAgIHByb2Nlc3M9JChlY2hvICIkaW5mbyIgfCBzZWQgLW4gIiR7bG9vcH1wIiB8IGF3ayAtRiAiXCIiICd7cHJpbnQgJDJ9JykKICAgICAgICBsaXN0ZW5faW5mbz0kKGVjaG8gIiRpbmZvIiB8IHNlZCAtbiAiJHtsb29wfXAiIHwgYXdrICd7cHJpbnQgJDV9JykKICAgICAgICBjb25uZWN0aW9uPSQoc3MgLW8gc3RhdGUgZXN0YWJsaXNoZWQgc3BvcnQgPSA6JHtsaXN0ZW5faW5mbyMjKjp9IHwgYXdrICd7cHJpbnQgJDV9JyB8IGdyZXAgLUVvICcoWzAtOV17MSwzfVwuKXszfVswLTldezEsM30nIHwgc29ydCAtdSB8IHdjIC1sKQogICAgICAgIG91dD0iJChwcmludGYgIiAgJFlFTExPVyUtMTJzICUtOHMgJS0xNXMgJS0zcyRCTEFOSwoiICRwcm9jZXNzICAkUElEICAkbGlzdGVuX2luZm8gICRjb25uZWN0aW9uKSIKICAgICAgICBvdXRzPSIkb3V0CiRvdXRzIgogICAgZG9uZQpkb25lCgplY2hvIC1lICIkb3V0cyIgfCBzZWQgIi9eJC9kIiB8IHNvcnQgLXUKCg==' | base64 -d >/usr/xbin/dk
    echo 'IyEvYmluL2Jhc2gKCmlmIFsgISAteiAiJDEiIF07IHRoZW4KICAgIHNlZCAtaSAnc3xcXHxcXFxcXFxcXHxnJyAkMQogICAgc2VkIC1pICdzfFwkfFxcJHxnJyAkMQogICAgc2VkIC1pICdzfCJ8XFxcInxnJyAkMQogICAgc2VkIC1pICc6YTtOOyQhYmE7c3xcbnxcXG58ZycgJDEKCiAgICBoZWFkPSQoYXdrIC1GICdcXFxcbicgJ3twcmludCAkMX0nICQxKQogICAgc2VkIC1pICdzfF4nJGhlYWQnfHByaW50ZiAiJXN8JyAkMQogICAgc2VkIC1pICJzfFwkfFwiICckaGVhZCd8IiAkMQoKICAgIGNhdCAkMQpmaQo=' | base64 -d >/usr/xbin/ee
    echo 'IyEvYmluL2Jhc2gKCgpjZCAvcm9vdC9naXRodWIKZ2l0IGFkZCAtLWFsbApnaXQgY29tbWl0IC1tICJ1cGRhdGUiCmdpdCBwdXNoIG9yaWdpbiBGSDA6bWFzdGVyCg==' | base64 -d >/usr/xbin/gitsc
    echo 'IyEvYmluL2Jhc2gKCmlwdGFibGVzIC1GCmlwdGFibGVzIC1YCmlwdGFibGVzIC1aCgo=' | base64 -d >/usr/xbin/iff
    echo 'IyEvYmluL2Jhc2gKCmlwdGFibGVzIC1TCg==' | base64 -d >/usr/xbin/ifs
    echo 'IyEvYmluL2Jhc2gKCmlwdGFibGVzIC10IG1hbmdsZSAtRgppcHRhYmxlcyAtdCBtYW5nbGUgLVgKaXB0YWJsZXMgLXQgbWFuZ2xlIC1aCgo=' | base64 -d >/usr/xbin/imf
    echo 'IyEvYmluL2Jhc2gKCmlwdGFibGVzIC10IG1hbmdsZSAtUwo=' | base64 -d >/usr/xbin/ims
    echo 'IyEvYmluL2Jhc2gKCmlwdGFibGVzIC10IG5hdCAtRgppcHRhYmxlcyAtdCBuYXQgLVgKaXB0YWJsZXMgLXQgbmF0IC1aCgo=' | base64 -d >/usr/xbin/inf
    echo 'IyEvYmluL2Jhc2gKCmlwdGFibGVzIC10IG5hdCAtUwo=' | base64 -d >/usr/xbin/ins
    echo 'IyEvYmluL2Jhc2gKCmlwdGFibGVzIC10IHJhdyAtRgppcHRhYmxlcyAtdCByYXcgLVgKaXB0YWJsZXMgLXQgcmF3IC1aCgo=' | base64 -d >/usr/xbin/irf
    echo 'IyEvYmluL2Jhc2gKCmlwdGFibGVzIC10IHJhdyAtUwo=' | base64 -d >/usr/xbin/irs
    echo 'IyEvYmluL2Jhc2gKCmVkaXRfdGV4dCgpewogICAgZXhwZWN0IDwoZWNobyAtZSAic3Bhd24gLW5vZWNobyB2aW0gJDFcbiAgICBhZnRlciAyMDBcbiAgICBzZW5kIFwiZ2c9R1xcbiAgICBcIlxuICAgIGFmdGVyIDUwMFxuICAgIHNlbmQgXCI6d3FcXG4gICAgXCJcbiAgICBpbnRlcmFjdCIpCiAgICBzZWQgLWkgInN8XHR8ICAgIHxnO3N8WyBcdF0qJHx8ZyIgJDEKfQoKanpkaF9wYW5lbCgpewogICAgdmFyPTEKICAgIFsgISAtZSAiJEhPTUUvLnNzaC9qemRoX2tub3duX2hvc3RzIiBdICYmIHRvdWNoICRIT01FLy5zc2gvanpkaF9rbm93bl9ob3N0cwogICAgY2xlYXIKICAgIGVjaG8KICAgIHByaW50ZiAiJTNzLiDkuLvopoHpnaLmnb9cbiIgIiQoKHZhcisrKSkiCiAgICBwcmludGYgIiUzcy4g5Liq5Lq66K6+572uXG4iICIkKCh2YXIrKykpIgogICAgcHJpbnRmICIlM3MuIOS4gOmUriBEZWJpYW4gMTBcbiIgIiQoKHZhcisrKSkiCiAgICBlY2hvIC1lICIkKGNhdCAke0hPTUV9Ly5zc2gvanpkaF9rbm93bl9ob3N0cyB8IHNlZCAnOmE7TjskIWJhO3N8XG58XFxufGcnKSIKCiAgICByZWFkIC1wICLor7fpgInmi6nvvJoiIHBhbmVsX2Nob2ljZQogICAgdnBzX2lwPSQoZWNobyAiJHBhbmVsX2Nob2ljZSIgfCBncmVwIC1FbyAnLipcLi4qJyAyPi9kZXYvbnVsbCB8IGF3ayAne3ByaW50ICQxfScgMj4vZGV2L251bGwpCiAgICBpZiBbIC16ICIkcGFuZWxfY2hvaWNlIiBdO3RoZW4KICAgICAgICBleGl0IDAKICAgIGVsaWYgWyAiJHBhbmVsX2Nob2ljZSIgPSAiMSIgXTt0aGVuCiAgICAgICAgYmFzaCA8KGN1cmwgLXNMIGh0dHBzOi8vcmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbS9GSDAvbnViaWEvbWFzdGVyL0JhY2tzdGFnZS5zaCkKICAgIGVsaWYgWyAiJHBhbmVsX2Nob2ljZSIgPSAiMiIgXTt0aGVuCiAgICAgICAgYmFzaCA8KGN1cmwgLXNMIGh0dHBzOi8vcmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbS9GSDAvbnViaWEvbWFzdGVyL3BlcnNvbl9zZXR0aW5ncy5zaCkKICAgIGVsaWYgWyAiJHBhbmVsX2Nob2ljZSIgPSAiMyIgXTt0aGVuCiAgICAgICAgcmVhZCAtcCAi6K+35Zue6L2m5Lul56Gu6K6k5pON5L2cIgogICAgICAgIGJhc2ggPChjdXJsIC1zTCBodHRwczovL3Jhdy5naXRodWJ1c2VyY29udGVudC5jb20vRkgwL251YmlhL21hc3Rlci9JbnN0YWxsTkVULnNoKSAtYSAtZCAxMCAtdiA2NAogICAgZWxpZiBbICEgLXogIiR2cHNfaXAiIF07dGhlbgogICAgICAgIHZwc19wb3J0PSQoZWNobyAiJHBhbmVsX2Nob2ljZSIgfCBhd2sgJ3twcmludCAkMn0nKQogICAgICAgIHZwc191c2VyPSQoZWNobyAiJHBhbmVsX2Nob2ljZSIgfCBhd2sgJ3twcmludCAkM30nKQogICAgICAgIHNlZCAtaSAiLyR2cHNfaXAgLioke3Zwc19wb3J0Oi0yMn0gLioke3Zwc191c2VyOi1yb290fS9kIiAke0hPTUV9Ly5zc2gvanpkaF9rbm93bl9ob3N0cwogICAgICAgIHNlZCAtaSAiLyR2cHNfaXAvZCIgJHtIT01FfS8uc3NoL2tub3duX2hvc3RzCiAgICAgICAgcHJpbnRmICJcXFwwMzNbMzNtICUtMTZzIFxcXDAzM1szMm0gJS01cyBcXFwwMzNbMzNtICUtOHMgXFxcXDAzM1swbVxuIiAkdnBzX2lwICR7dnBzX3BvcnQ6LTIyfSAke3Zwc191c2VyOi1yb290fSA+PiAke0hPTUV9Ly5zc2gvanpkaF9rbm93bl9ob3N0cwogICAgICAgIHNlZCAtaSAiL14kL2Q7L14jL2Q7c3xeWyBcdF0qWzAtOV0qXC58fGciICR7SE9NRX0vLnNzaC9qemRoX2tub3duX2hvc3RzCiAgICAgICAgc3NoX2xpbmVzPSQoY2F0ICR7SE9NRX0vLnNzaC9qemRoX2tub3duX2hvc3RzIHwgd2MgLWwpCiAgICAgICAgc3NoX3Zhcj0kKHNlcSAxICRzc2hfbGluZXMpCiAgICAgICAgZm9yIHZhciBpbiAkc3NoX3ZhcjtkbwogICAgICAgICAgICBzZWQgLWkgIiR7dmFyfXN8XnwkKHByaW50ZiAiJTNzIiAkKCgkdmFyKzMpKSlcLnwiICR7SE9NRX0vLnNzaC9qemRoX2tub3duX2hvc3RzCiAgICAgICAgZG9uZQogICAgICAgIHNlZCAtaSAnMXN8XnxcbnwnICR7SE9NRX0vLnNzaC9qemRoX2tub3duX2hvc3RzCiAgICAgICAgZWNobyA+PiR7SE9NRX0vLnNzaC9qemRoX2tub3duX2hvc3RzCiAgICAgICAgc3NoIC1vIHN0cmljdGhvc3RrZXljaGVja2luZz1ubyAtcCAke3Zwc19wb3J0Oi0yMn0gJHt2cHNfdXNlcjotcm9vdH1AJHZwc19pcCAyPi9kZXYvbnVsbAogICAgZWxzZQogICAgICAgIHZwc19pbmZvPSQoc2VkIC1uICIkKCgkKGVjaG8gJHBhbmVsX2Nob2ljZSB8IGdyZXAgLUVvICJbMC05XVswLTldKiIpLTIpKXAiICR7SE9NRX0vLnNzaC9qemRoX2tub3duX2hvc3RzKQogICAgICAgIHZwc19pcD0kKGVjaG8gJHZwc19pbmZvIHwgYXdrICd7cHJpbnQgJDJ9JykKICAgICAgICB2cHNfcG9ydD0kKGVjaG8gJHZwc19pbmZvIHwgYXdrICd7cHJpbnQgJDR9JykKICAgICAgICB2cHNfdXNlcj0kKGVjaG8gJHZwc19pbmZvIHwgYXdrICd7cHJpbnQgJDZ9JykKICAgICAgICBpZiBlY2hvICRwYW5lbF9jaG9pY2UgfCBncmVwIC1xICJeWzAtOV0qXCQiO3RoZW4KICAgICAgICAgICAgc3NoIC1wICR2cHNfcG9ydCAkdnBzX3VzZXJAJHZwc19pcAogICAgICAgIGVsaWYgZWNobyAkcGFuZWxfY2hvaWNlIHwgZ3JlcCAtcSAiZFwkIjt0aGVuCiAgICAgICAgICAgIHNlZCAtaSAiLyR2cHNfaXAvZCIgJHtIT01FfS8uc3NoL2p6ZGhfa25vd25faG9zdHMKICAgICAgICAgICAgc2VkIC1pICIvJHZwc19pcC9kIiAke0hPTUV9Ly5zc2gva25vd25faG9zdHMKICAgICAgICAgICAgc2VkIC1pICIvXiQvZDsvXiMvZDtzfF5bIFx0XSpbMC05XSpcLnx8ZyIgJHtIT01FfS8uc3NoL2p6ZGhfa25vd25faG9zdHMKICAgICAgICAgICAgc3NoX2xpbmVzPSQoY2F0ICR7SE9NRX0vLnNzaC9qemRoX2tub3duX2hvc3RzIHwgd2MgLWwpCiAgICAgICAgICAgIHNzaF92YXI9JChzZXEgMSAkc3NoX2xpbmVzKQogICAgICAgICAgICBmb3IgdmFyIGluICRzc2hfdmFyO2RvCiAgICAgICAgICAgICAgICBzZWQgLWkgIiR7dmFyfXN8XnwkKHByaW50ZiAiJTNzIiAkKCgkdmFyKzMpKSlcLnwiICR7SE9NRX0vLnNzaC9qemRoX2tub3duX2hvc3RzCiAgICAgICAgICAgIGRvbmUKICAgICAgICAgICAgc2VkIC1pICcxc3xefFxufCcgJHtIT01FfS8uc3NoL2p6ZGhfa25vd25faG9zdHMKICAgICAgICAgICAgZWNobyA+PiR7SE9NRX0gLnNzaC9qemRoX2tub3duX2hvc3RzCiAgICAgICAgZWxpZiBlY2hvICRwYW5lbF9jaG9pY2UgfCBncmVwIC1xICJmXCQiO3RoZW4KICAgICAgICAgICAgc2Z0cCAtUCAkdnBzX3BvcnQgJHZwc191c2VyQCR2cHNfaXAKICAgICAgICBmaSAyPi9kZXYvbnVsbAogICAgZmkKICAgICMgY2xlYXIKfQoKaWYgWyAteiAiJDEiIF07dGhlbgogICAganpkaF9wYW5lbAplbGlmIFsgLWUgIiQxIiBdO3RoZW4KICAgIGVkaXRfdGV4dCAkMQpmaQoK' | base64 -d >/usr/xbin/j
    echo 'IyEvYmluL2Jhc2gKCndoaWxlIHRydWU7ZG8KCWNkIC9yb290L0ZIMC5naXRodWIuaW8KCWJ1bmRsZSBleGVjIGpla3lsbCBzIC0taG9zdCAwLjAuMC4wIC0tcG9ydCA4MDggJgoJamVreWxsX3BpZD0kIQoJcmVhZAoJa2lsbCAkamVreWxsX3BpZApkb25lCg==' | base64 -d >/usr/xbin/jfx
    echo 'IyEvYmluL2Jhc2gKCm1ha2UgLXFwIHwgZ3JlcCAtRW8gJ15bYS16QS1aMC05LV0qOicgfCBzZWQgJ3N8Onx8ZycgfCBzb3J0IC11Cgo=' | base64 -d >/usr/xbin/mls
    echo 'IyEvYmluL2Jhc2gKClsgIiQxIiA9ICItZCIgLW8gIiQxIiA9ICItRCIgXSAmJiBGTEFHUz0iLS1kYWVtb24gPi9kZXYvbnVsbCAyPiYxIgoKaWYgaWZjb25maWcgYXAwID4vZGV2L251bGwgMj4mMTt0aGVuCiAgICBjcmVhdGVfYXAgLS1zdG9wIHdscDBzMjBmMwpmaQoKaWYgaWZjb25maWcgZW5wMnMwIDI+JjEgfCBncmVwIC1xICdpbmV0ICc7dGhlbgogICAgaWY9ZW5wMnMwCmVsc2UKICAgIGlmPXdscDBzMjBmMwpmaQoKWyAiJDEiID0gIi1kIiAtbyAiJDEiID0gIi1EIiBdICYmIFwKICAgIGNyZWF0ZV9hcCB3bHAwczIwZjMgJGlmIEhQX1o2NiAxMzQ2NzkwMCAtLWZyZXEtYmFuZCA1IC1jIDE0OSAtLWRhZW1vbiA+L2Rldi9udWxsIDI+JjEK' | base64 -d >/usr/xbin/rd
    echo 'IyEvYmluL2Jhc2gKCgpPTEQ9JDEKUkVQTEFDRT0kMgp6aXBfZmlsZT0kKGxzICouemlwIDI+L2Rldi9udWxsKQoKZm9yIHVuemlwX2ZpbGUgaW4gJHppcF9maWxlO2RvCiAgICBybSAtcmYgJHt1bnppcF9maWxlJS56aXB9CiAgICB1bnppcCAtcSAtbyAkdW56aXBfZmlsZSAtZCAke3VuemlwX2ZpbGUlLnppcH0KZG9uZQoKc2VkIC1pICJzfCRPTER8JFJFUExBQ0V8ZyIgJChncmVwIC1ybCAiJE9MRCIgLikKCmZvciByZXppcF9maWxlIGluICR6aXBfZmlsZTtkbwogICAgY2QgJHtyZXppcF9maWxlJS56aXB9CiAgICBybSAtZiAuLi8kcmV6aXBfZmlsZQogICAgemlwIC1xIC1yIC4uLyRyZXppcF9maWxlICoKICAgIGNkIC4uCmRvbmUKCmZvciBybV9maWxlIGluICR6aXBfZmlsZTtkbwogICAgcm0gLXJmICR7cm1fZmlsZSUuemlwfQpkb25lCgo=' | base64 -d >/usr/xbin/spsed
    echo 'IyEvYmluL2Jhc2gKCmZvciBmaWxlIGluICRAO2RvCgljdXJsIC1zTCAtRiAiZmlsZT1AJGZpbGUiIGh0dHBzOi8vZmlsZS5pbyB8IGF3ayAtRiAnIicgJ3twcmludCAkMTB9Jwpkb25lCg==' | base64 -d >/usr/xbin/uf
    chmod +x -R /usr/xbin
}

rc_local() {
    command -v systemctl >/dev/null || return
    echo -e '[Unit]\nDescription=/etc/rc.local\nConditionPathExists=/etc/rc.local\n\n[Service]\nType=forking\nExecStart=/etc/rc.local start\nTimeoutSec=0\nStandardOutput=tty\nRemainAfterExit=yes\nSysVStartPriority=99\n\n[Install]\nWantedBy=multi-user.target' >/etc/systemd/system/rc-local.service
    chmod +x /etc/systemd/system/rc-local.service
    systemctl daemon-reload
    echo -e '#!/bin/sh -e\nexit 0' >/etc/rc.local
    chmod +x /etc/rc.local
    systemctl enable rc-local
} >/dev/null 2>&1

set_bash() {
    cd /root
    country=$(curl -sL http://ip-api.com/json | sed 's|.*"countryCode":"\(..\)".*|\1|')
    system="debian" && command -v yum >/dev/null && system="centos"
    sed -i '/JZDH/d' .bashrc

    echo -e "PS1='\\\n\\\[\\\e[47;30m\\\][$country]\\\u@$system\\\[\\\e[m\\\]:[\$(pwd)]\\\n\\\\$ ' #JZDH" >>.bashrc
    echo 'LS_COLORS="rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:" #JZDH' >>.bashrc
    echo 'alias ls="ls --color=auto" #JZDH' >>.bashrc
    echo 'alias vi="vim" #JZDH' >>.bashrc
    echo 'alias grep="grep --color=auto" #JZDH' >>.bashrc
    echo "clear #JZDH" >>.bashrc
    echo "export PATH=\"\$PATH:/usr/xbin\" #JZDH" >>/root/.bashrc

    #默认记录 500 条，调整成 100,000 条
    echo 'HISTSIZE=100000 #JZDH' >>/root/.bashrc

    #记录命令的执行时间
    echo "HISTTIMEFORMAT='%F %T  ' #JZDH" >>/root/.bashrc

    #实时记录
    echo "shopt -s histappend #JZDH" >>/root/.bashrc
    echo "PROMPT_COMMAND='history -a' #JZDH" >>/root/.bashrc

    #开启 gcc 颜色
    export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
    echo "export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01' #JZDH" >>/root/.bashrc

    chmod 644 .bashrc
}

set_nano() {
    command -v git >/dev/null && git clone https://github.com/scopatz/nanorc.git /usr/local/share/nano
    echo -e 'set smooth\n	set morespace\n	set tabsize 4\n	set tabstospaces\n	set nohelp\n	set nowrap' >/root/.nanorc
    ls /usr/share/nano/*.nanorc | sed 's|^|include |g' >>/root/.nanorc
}

clean_iptables() {
    [ -f "/etc/systemd/system/clean_iptables.service" ] && return 0
    echo -e '#!/bin/bash\nexport PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"' >/bin/clean_iptables
    chmod 755 /bin/clean_iptables
    for chain in filter nat mangle raw; do
        iptables -t $chain -S | grep "\-[AI] " | sed "s|-[AI] |-D |g;s|^|iptables -t $chain |g" >>/bin/clean_iptables
        iptables -t $chain -S | grep "\-N " | sed "s|-N |-X |g;s|^|iptables -t $chain |g" >>/bin/clean_iptables
    done
    echo -e "[Unit]\nDescription=clean_iptables Service\nAfter=network.target\n\n[Service]\nType=forking\nExecStart=/bin/clean_iptables\n\n[Install]\nWantedBy=multi-user.target" >/etc/systemd/system/clean_iptables.service
    systemctl daemon-reload
    systemctl enable clean_iptables.service
    /bin/clean_iptables
} >/dev/null 2>&1

clean_aliyun() {
    for clean in $(find /usr -name *[Aa][Ll][Ii][Yy][Uu][Nn]* | grep -v "_bak"); do
        mv $clean ${clean}_bak
    done
    for clean in $(find /etc -name *[Aa][Ll][Ii][Yy][Uu][Nn]* | grep -v "_bak"); do
        mv $clean ${clean}_bak
    done
} >/dev/null 2>&1

adjust_dns() {
    rm -f /etc/resolv.conf
    echo 'nameserver 8.8.8.8' >/etc/resolv.conf
    chattr +i /etc/resolv.conf
    grep -q 'systemd-resolved' /etc/resolv.conf || return 0
    systemctl stop systemd-resolved.service
    systemctl disable systemd-resolved.service
} >/dev/null 2>&1

remove_snapd() {
    command -v snap || return
    apt autoremove --purge snapd -y
    rm -rf /root/snap
} >/dev/null 2>&1

close_selinux() {
    setenforce 0
    sed -i '/SELINUX=/cSELINUX=disabled' /etc/selinux/config
} >/dev/null 2>&1

set_timezone() {
    if [ -e "/etc/localtime" -a -e "/usr/share/zoneinfo/Asia/Shanghai" ]; then
        ls -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
    fi
}

install_command_not_found() {
    if command -v apt >/dev/null 2>&1; then
        apt update
        apt install command-not-found apt-file -y
        apt-file update
        update-command-not-found
    fi
}

main() {
    clean_iptables
    close_selinux
    # clean_aliyun
    handle_sshd_config
    person_bin
    rc_local
    set_bash
    set_nano
    adjust_dns
    remove_snapd
    set_timezone
    install_command_not_found
}

main
