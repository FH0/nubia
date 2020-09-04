
security=auto
vps_ip=
port=
uuid=
alterId=32
Host=k.youku.com
path=/
network=GET
DNS=114.114.114.114
mux=
tls=off

#abroad_security=auto
#abroad_vps_ip=
#abroad_port=
#abroad_uuid=
#abroad_alterId=32
#abroad_Host=k.youku.com
#abroad_path=/
#abroad_network=GET
#abroad_DNS=8.8.8.8
#abroad_mux=
#abroad_tls=off

hot_proxy=on
break_bq=off
block_ads=on
app_direct=""
app_proxy=""
ChinaDNS=
wifi_proxy=on
auto_start=off
loglevel=

#================================================================
#
#    vps_ip是服务器IP
#    port是端口
#    network可选GET POST CONNECT ws kcp
#    alterId是额外用户ID
#    Host是混淆
#    path是首头，当network为tcp或ws时生效
#    security是加密方式，可选auto chacha20-poly1305 aes-128-gcm aes-128-cfb none
#    mux不为空时开启mux，需填入一个数字
#    tls，需要vps_ip为域名，可选on off
#    DNS项为空时不代理DNS
#
#    当同时拥有国内节点与国外节点时，可以使用双服务器模式，其他情况不行
#    双服务器模式不推荐Wifi或无限流量用户使用，Wifi或无限流量用户推荐使用ChinaDNS
#    启用双服务器模式后ChinaDNS与break_bq失效
#    取消abroad_前缀参数前的注释即可开启双服务器模式，不用的时候注释abroad_vps_ip即可
#    开启后国内流量走原来的节点，国外流量走abroad_前缀的节点
#    双服务器模式下，国外节点传输设置继承国内节点
#    abroad_tls，需要abroad_vps_ip为域名，可选on off
#
#    break_bq是破版权，同时对本机与热点有效，可选on off
#    block_ads是v2ray域名文件自带的去广告功能，效果未知，可选on off
#    hot_proxy是热点代理开关，可选on off
#    app_proxy是代理应用，未选中的应用会被放行，优先级高于app_direct，可选[应用包名] [应用uid]，多个应用之间用空格隔开
#    app_direct是放行应用，未被放行的应用会被代理，可选[应用包名] [应用uid]，多个应用之间用空格隔开
#    当ChinaDNS不为空时，只代理国外流量，同时对本机与热点生效，填一个国内的DNS服务器地址，不能与DNS的值相同
#    wifi_proxy是WiFi代理开关，可选on off
#    auto_start是利用magisk开机自启的开关，可选on off，magisk版本不能低于19
#    loglevel是v2ray自带的错误日志功能，默认error，可选debug info warning error
#
#    {常用的应用包名}
#    淘宝           com.taobao.taobao
#    支付宝         com.eg.android.AlipayGphone
#    王者荣耀       com.tencent.tmgp.sgame
#    刺激战场       com.tencent.tmgp.pubgmhd
#    联通营业厅     com.sinovatech.unicom.ui
#    作业帮         com.baidu.homework
#    Tim            com.tencent.tim
#    ADM            com.dv.adm.pay
#    酷安           com.coolapk.market
#    电信营业厅     com.ct.client
#    京东           com.jingdong.app.mall
#    网易云音乐     com.netease.cloudmusic
#    JuiceSSH       com.sonelli.juicessh
#    微信           com.tencent.mm
#    腾讯视频       com.tencent.qqlive
#    微信读书       com.tencent.weread
#    转转           com.wuba.zhuanzhuan
#    闲鱼           com.taobao.idlefish
#    讯飞输入法     com.iflytek.inputmethod
#    哔哩哔哩       tv.danmaku.bili
#    YY             com.duowan.mobile
#    QQ音乐         com.tencent.qqmusic
#    Network Tools  net.he.networktools
#    阿里云         com.alibaba.aliyun
#    WPS            cn.wps.moffice_eng
#    网络信号大师   com.qtrun.QuickTest
#    Z直播          com.linroid.zlive
#    决战！平安京   com.netease.moba
#    翼支付         com.chinatelecom.bestpayclient
#    To-Do          com.microsoft.todos
#    微软桌面       com.microsoft.launcher
#    Via            mark.via.gp
#
#    {相关的说明}
#    1.V2Ray搭建脚本[Debian9/CentOS7]:    bash <(curl -sL https://raw.githubusercontent.com/FH0/nubia/master/Backstage.sh)
#    2.如果提示curl: command not found，请先安装curl，(apt-get update && apt-get install curl -y) || yum install curl -y
#
#===============================================================
wp=$(dirname $(readlink -f $0))
v2local_cmd=start . $wp/bin/v2local_function.sh
