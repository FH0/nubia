cat > /root/cxll <<'GOST'
python /usr/local/SSR-Bash-Python/show_flow.py > /root/cx.txt
a=`sed -n '2p' /root/cx.txt | grep -Eo '[0-9]+MB' | grep -Eo '[0-9]+'`
b=`sed -n '3p' /root/cx.txt | grep -Eo '[0-9]+MB' | grep -Eo '[0-9]+'`
c=`sed -n '4p' /root/cx.txt | grep -Eo '[0-9]+MB' | grep -Eo '[0-9]+'`
let "b+=$a"
let "b+=$c"
b=`expr $b / 1024`
if [ "$b" -gt "1024" ] ; then
bash /usr/local/shadowsocksr/stop.sh
fi
sleep 10m
date '+%s' > /root/cxll.log
sh /root/cxll

GOST
chmod +x /root/cxll
echo 'setsid sh /root/cxll' > /etc/rc.d/init.d/cxll
chmod /etc/rc.d/init.d/cxll
echo '/etc/rc.d/init.d/cxll' >> /etc/rc.d/rc.local
