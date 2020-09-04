
write_log(){
    strings="\  \"log\": {\n    \"access\": \"none\",\n    \"loglevel\": \"${loglevel:-error}\"\n  },"
    sed -i "\$a$strings" $wp/bin/config.json
}

write_policy(){
    strings="\  \"policy\": {\n    \"levels\": {\n      \"0\": {\n        \"uplinkOnly\": 0,\n        \"downlinkOnly\": 0\n      }\n    }\n  },"
    sed -i "\$a$strings" $wp/bin/config.json
}

write_dns(){
    if [ ! -z "$abroad_vps_ip" ];then
        strings="\  \"dns\": {\n    \"servers\": [\n      \"$abroad_DNS\",\n      {\n        \"address\": \"$DNS\",\n        \"port\": 53,\n        \"domains\": [\n          \"geosite:cn\"\n        ]\n      }\n    ]\n  },"
    elif [ ! -z "$ChinaDNS" ];then
        strings="\  \"dns\": {\n    \"servers\": [\n      \"$DNS\",\n      {\n        \"address\": \"$ChinaDNS\",\n        \"port\": 53,\n        \"domains\": [\n          \"geosite:cn\"\n        ]\n      }\n    ]\n  },"
    else
        strings="\  \"dns\": {\n    \"servers\": [\n      \"$DNS\"\n    ]\n  },"
    fi
    sed -i "\$a$strings" $wp/bin/config.json
}

write_routing(){
    vps_ip_type="ip" && echo $vps_ip | grep -qE '([0-9]{1,3}\.){3}[0-9]{1,3}' || vps_ip_type="domain"
    if [ ! -z "$abroad_vps_ip" ];then
		abroad_vps_ip_type="ip" && echo $abroad_vps_ip | grep -qE '([0-9]{1,3}\.){3}[0-9]{1,3}' || abroad_vps_ip_type="domain"
    fi
    if [ "$block_ads" = "on" ];then
        adStrings="      {\n        \"type\": \"field\",\n        \"domain\": [\n          \"geosite:category-ads-all\"\n        ],\n        \"outboundTag\": \"drop\"\n      },\n"
    fi
    
    if [ ! -z "$abroad_vps_ip" ];then
        strings="\  \"routing\": {\n    \"domainStrategy\": \"IPIfNonMatch\",\n    \"rules\": [\n$adStrings      {\n        \"inboundTag\": [\n          \"udp\"\n        ],\n        \"network\": \"udp\",\n        \"port\": \"53\",\n        \"outboundTag\": \"dns-out\",\n        \"type\": \"field\"\n      },\n      {\n        \"type\": \"field\",\n        \"$vps_ip_type\": [\n          \"$vps_ip\"\n        ],\n        \"port\": \"$port\",\n        \"outboundTag\": \"direct\"\n      },\n      {\n        \"type\": \"field\",\n        \"$abroad_vps_ip_type\": [\n          \"$abroad_vps_ip\"\n        ],\n        \"port\": \"$abroad_port\",\n        \"outboundTag\": \"direct\"\n      },\n      {\n        \"type\": \"field\",\n        \"ip\": [\n          \"geoip:cn\"\n        ],\n        \"outboundTag\": \"B\"\n      },\n      {\n        \"type\": \"field\",\n        \"domain\": [\n          \"geosite:cn\"\n        ],\n        \"outboundTag\": \"B\"\n      }\n    ]\n  },"
    elif [ ! -z "$ChinaDNS" ];then
        strings="\  \"routing\": {\n    \"domainStrategy\": \"IPIfNonMatch\",\n    \"rules\": [\n$adStrings      {\n        \"inboundTag\": [\n          \"udp\"\n        ],\n        \"network\": \"udp\",\n        \"port\": \"53\",\n        \"outboundTag\": \"dns-out\",\n        \"type\": \"field\"\n      },\n      {\n        \"type\": \"field\",\n        \"$vps_ip_type\": [\n          \"$vps_ip\"\n        ],\n        \"outboundTag\": \"direct\"\n      },\n      {\n        \"type\": \"field\",\n        \"ip\": [\n          \"geoip:cn\"\n        ],\n        \"outboundTag\": \"direct\"\n      },\n      {\n        \"type\": \"field\",\n        \"domain\": [\n          \"geosite:cn\"\n        ],\n        \"outboundTag\": \"direct\"\n      }\n    ]\n  },"
    elif [ "$break_bq" = "on" ];then
        strings="\  \"routing\": {\n    \"domainStrategy\": \"IPIfNonMatch\",\n    \"rules\": [\n$adStrings      {\n        \"inboundTag\": [\n          \"udp\"\n        ],\n        \"network\": \"udp\",\n        \"port\": \"53\",\n        \"outboundTag\": \"dns-out\",\n        \"type\": \"field\"\n      },\n      {\n        \"type\": \"field\",\n        \"$vps_ip_type\": [\n          \"$vps_ip\"\n        ],\n        \"port\": \"$port\",\n        \"outboundTag\": \"direct\"\n      },\n      {\n        \"type\": \"field\",\n        \"network\": \"tcp\",\n        \"outboundTag\": \"direct\",\n        \"domain\": [\n          \"guide-acs.m.taobao.com\",\n          \"mobile.api.mgtv.com\",\n          \"cache.video.iqiyi.com\",\n          \"pcweb2.api.mgtv.com\",\n          \"video.qq.com\",\n          \"api.bilibili.com\",\n          \"interface3.music.163.com\",\n          \"api3-normal-c-hl.ixigua.com\",\n          \"www.ixigua.com\",\n          \"v.youku.com\"\n        ]\n      }\n    ]\n  },"
    else
        strings="\  \"routing\": {\n    \"domainStrategy\": \"IPIfNonMatch\",\n    \"rules\": [\n$adStrings      {\n        \"inboundTag\": [\n          \"udp\"\n        ],\n        \"network\": \"udp\",\n        \"port\": \"53\",\n        \"outboundTag\": \"dns-out\",\n        \"type\": \"field\"\n      },\n      {\n        \"type\": \"field\",\n        \"$vps_ip_type\": [\n          \"$vps_ip\"\n        ],\n        \"port\": \"$port\",\n        \"outboundTag\": \"direct\"\n      }\n    ]\n  },"
    fi
    sed -i "\$a$strings" $wp/bin/config.json
}

write_inbounds(){
    if [ "$proxy_mode" = "notun" ];then
        udpStrings="    {\n      \"port\": 1112,\n      \"protocol\": \"dokodemo-door\",\n      \"settings\": {\n        \"network\": \"udp\",\n        \"followRedirect\": true\n      },\n      \"tag\": \"udp\"\n    }\n"
    else
        udpStrings="    {\n      \"port\": 1112,\n      \"protocol\": \"socks\",\n      \"settings\": {\n        \"auth\": \"noauth\",\n        \"udp\": true\n      },\n      \"tag\": \"udp\"\n    }\n"
    fi
	strings="\  \"inbounds\": [\n    {\n      \"port\": 1111,\n      \"protocol\": \"dokodemo-door\",\n      \"sniffing\": {\n        \"enabled\": true,\n        \"destOverride\": [\n          \"tls\",\n          \"http\"\n        ]\n      },\n      \"settings\": {\n        \"network\": \"tcp\",\n        \"followRedirect\": true\n      }\n    },\n$udpStrings  ],"
	sed -i "\$a$strings" $wp/bin/config.json
}

write_outbounds(){
	if [ ! -z "$abroad_vps_ip" ];then
		[ ! -z "$abroad_mux" ] && abroad_muxStrings="      \"mux\": {\n        \"enabled\": true,\n        \"concurrency\": $abroad_mux\n      },\n"
		[ "$abroad_tls" = "on" ] && abroad_tlsStrings="      \"security\": \"tls\",\n      \"tlsSettings\": {\n        \"serverName\": \"$abroad_vps_ip\",\n        \"allowInsecure\": true\n      },\n"
		if [ "$abroad_network" = "ws" ];then
			abroad_strings="\    {\n$abroad_muxStrings      \"protocol\": \"vmess\",\n      \"settings\": {\n        \"vnext\": [\n          {\n            \"address\": \"$abroad_vps_ip\",\n            \"port\": $abroad_port,\n            \"users\": [\n              {\n                \"id\": \"$abroad_uuid\",\n                \"alterId\": $abroad_alterId,\n                \"security\": \"$abroad_security\"\n              }\n            ]\n          }\n        ]\n      },\n      \"streamSettings\": {\n        \"network\": \"ws\",\n$abroad_tlsStrings        \"wsSettings\": {\n          \"path\": \"$abroad_path\",\n          \"headers\": {\n            \"Host\": \"$abroad_Host\"\n          }\n        }\n      },\n     \"tag\": \"A\"\n    },\n"
		elif [ "$abroad_network" = "GET" -o "$abroad_network" = "POST" -o "$abroad_network" = "CONNECT" ];then
			abroad_strings="\    {\n$abroad_muxStrings      \"protocol\": \"vmess\",\n      \"settings\": {\n        \"vnext\": [\n          {\n            \"address\": \"$abroad_vps_ip\",\n            \"port\": $abroad_port,\n            \"users\": [\n              {\n                \"id\": \"$abroad_uuid\",\n                \"alterId\": $abroad_alterId,\n                \"security\": \"$abroad_security\"\n              }\n            ]\n          }\n        ]\n      },\n      \"streamSettings\": {\n        \"network\": \"tcp\",\n$abroad_tlsStrings        \"tcpSettings\": {\n          \"header\": {\n            \"type\": \"http\",\n            \"request\": {\n              \"version\": \"1.1\",\n              \"method\": \"$abroad_network\",\n              \"path\": [\n                \"$abroad_path\"\n              ],\n              \"headers\": {\n                \"Host\": \"$abroad_Host\"\n              }\n            }\n          }\n        }\n      },\n      \"tag\": \"A\"\n    },\n"
		else
			abroad_strings="\    {\n$abroad_muxStrings      \"protocol\": \"vmess\",\n      \"settings\": {\n        \"vnext\": [\n          {\n            \"address\": \"$abroad_vps_ip\",\n            \"port\": $abroad_port,\n            \"users\": [\n              {\n                \"id\": \"$abroad_uuid\",\n                \"alterId\": $abroad_alterId,\n                \"security\": \"$abroad_security\"\n              }\n            ]\n          }\n        ]\n      },\n      \"streamSettings\": {\n        \"network\": \"kcp\",\n$abroad_tlsStrings        \"kcpSettings\": {\n          \"mtu\": 1350,\n          \"tti\": 50,\n          \"uplinkCapacity\": 5,\n          \"downlinkCapacity\": 20,\n          \"header\": {\n            \"type\": \"none\"\n          }\n        }\n      },\n       \"tag\": \"A\"\n    },\n"
		fi
	fi
    [ ! -z "$mux" ] && muxStrings="      \"mux\": {\n        \"enabled\": true,\n        \"concurrency\": $mux\n      },\n"
    [ "$tls" = "on" ] && tlsStrings="      \"security\": \"tls\",\n      \"tlsSettings\": {\n        \"serverName\": \"$vps_ip\",\n        \"allowInsecure\": true\n      },\n"
    if [ "$network" = "ws" ];then
		strings="\  \"outbounds\": [\n$abroad_strings    {\n$muxStrings      \"protocol\": \"vmess\",\n      \"settings\": {\n        \"vnext\": [\n          {\n            \"address\": \"$vps_ip\",\n            \"port\": $port,\n            \"users\": [\n              {\n                \"id\": \"$uuid\",\n                \"alterId\": $alterId,\n                \"security\": \"$security\"\n              }\n            ]\n          }\n        ]\n      },\n      \"streamSettings\": {\n        \"network\": \"ws\",\n$tlsStrings        \"wsSettings\": {\n          \"path\": \"$path\",\n          \"headers\": {\n            \"Host\": \"$Host\"\n          }\n        }\n      },\n      \"tag\": \"B\"\n    },\n    {\n      \"protocol\": \"freedom\",\n      \"settings\": {\n        \"domainStrategy\": \"UseIP\"\n      },\n      \"tag\": \"direct\"\n    },\n    {\n      \"protocol\": \"blackhole\",\n      \"settings\": {},\n      \"tag\": \"drop\"\n    },\n    {\n      \"protocol\": \"dns\",\n      \"tag\": \"dns-out\"\n    }\n  ]"
    elif [ "$network" = "GET" -o "$network" = "POST" -o "$network" = "CONNECT" ];then
		strings="\  \"outbounds\": [\n$abroad_strings    {\n$muxStrings      \"protocol\": \"vmess\",\n      \"settings\": {\n        \"vnext\": [\n          {\n            \"address\": \"$vps_ip\",\n            \"port\": $port,\n            \"users\": [\n              {\n                \"id\": \"$uuid\",\n                \"alterId\": $alterId,\n                \"security\": \"$security\"\n              }\n            ]\n          }\n        ]\n      },\n      \"streamSettings\": {\n        \"network\": \"tcp\",\n$tlsStrings        \"tcpSettings\": {\n          \"header\": {\n            \"type\": \"http\",\n            \"request\": {\n              \"version\": \"1.1\",\n              \"method\": \"$network\",\n              \"path\": [\n                \"$path\"\n              ],\n              \"headers\": {\n                \"Host\": \"$Host\"\n              }\n            }\n          }\n        }\n      },\n      \"tag\": \"B\"\n    },\n    {\n      \"protocol\": \"freedom\",\n      \"settings\": {\n        \"domainStrategy\": \"UseIP\"\n      },\n      \"tag\": \"direct\"\n    },\n    {\n      \"protocol\": \"blackhole\",\n      \"settings\": {},\n      \"tag\": \"drop\"\n    },\n    {\n      \"protocol\": \"dns\",\n      \"tag\": \"dns-out\"\n    }\n  ]"
    else
		strings="\  \"outbounds\": [\n$abroad_strings    {\n$muxStrings      \"protocol\": \"vmess\",\n      \"settings\": {\n        \"vnext\": [\n          {\n            \"address\": \"$vps_ip\",\n            \"port\": $port,\n            \"users\": [\n              {\n                \"id\": \"$uuid\",\n                \"alterId\": $alterId,\n                \"security\": \"$security\"\n              }\n            ]\n          }\n        ]\n      },\n      \"streamSettings\": {\n        \"network\": \"kcp\",\n$tlsStrings        \"kcpSettings\": {\n          \"mtu\": 1350,\n          \"tti\": 50,\n          \"uplinkCapacity\": 5,\n          \"downlinkCapacity\": 20,\n          \"header\": {\n            \"type\": \"none\"\n          }\n        }\n      },\n      \"tag\": \"B\"\n    },\n    {\n      \"protocol\": \"freedom\",\n      \"settings\": {\n        \"domainStrategy\": \"UseIP\"\n      },\n      \"tag\": \"direct\"\n    },\n    {\n      \"protocol\": \"blackhole\",\n      \"settings\": {},\n      \"tag\": \"drop\"\n    },\n    {\n      \"protocol\": \"dns\",\n      \"tag\": \"dns-out\"\n    }\n  ]"
    fi
    sed -i "\$a$strings" $wp/bin/config.json
}

vim_config(){
    echo "{" > $wp/bin/config.json
    write_log
#    write_policy
    if [ ! -z "$DNS" ];then
        write_dns
    fi
    write_routing
    write_inbounds
    write_outbounds
    sed -i "\$a}" $wp/bin/config.json
}
