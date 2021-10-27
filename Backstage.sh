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
    read $VARIABLE </dev/tty
    echo
}

cmd_need() {
    update_flag=0
    exit_flag=0

    for cmd in $1; do
        if ! command -v $cmd >/dev/null 2>&1; then
            # check if auto install
            if command apt >/dev/null 2>&1; then
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
            elif command yum >/dev/null 2>&1; then
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

install_tool() {
    key="$1"
    if [ -d "/usr" -a ! -z "$(command -v apt-get yum)" ]; then
        wp="/usr/local/$key"
    else
        colorRead $YELLOW "请输入安装目录，例如：/usr/local，不能是/bin " wp
        [ -z "$wp" ] && exit 1
        wp=$(echo "$wp/$key" | sed 's|///*|/|g') # 连续的 / 变为一个
    fi
    file="$key.tar"
    if [ -d "$wp" ]; then
        colorEcho $YELLOW "正在卸载 $key ..."
        bash $wp/uninstall.sh >/dev/null 2>&1
    fi
    colorEcho $YELLOW "正在安装 $key 到 $wp ..."
    rm -rf $wp
    mkdir -p $wp
    curl -L "https://raw.githubusercontent.com/FH0/nubia/master/linux-tools/$file" |
        tar -C $wp -xf-
    sed -i "s|wp=.*|wp=\"$wp\"|g" $wp/*.sh # 修改路径
    bash $wp/install.sh
}

check_environment() {
    if [ "${EUID:-$(id -u)}" != "0" ]; then
        colorEcho $RED "请切换到 root 用户后再执行此脚本！"
        exit 1
    fi

    if [ "$(uname -r | awk -F '.' '{print $1}')" -lt "3" ]; then
        colorEcho $RED "内核不支持，请升级内核或更新系统！"
        exit 1
    fi
}

tools_add() {
    tools="$tools$1 $2\n"
}

panel() {
    clear

    check_environment
    cmd_need 'iptables tar netstat curl'

    for tool in $(curl -L "http://github.com/FH0/nubia/tree/master/linux-tools" | grep -Eo '[0-9a-zA-Z_-]+\.tar' | sort -u | sed 's|\.tar||g'); do
        tools_add "$tool" "$tool"
    done

    colorEcho $BLUE "欢迎使用 JZDH 集合脚本"
    var=1
    echo -e "$tools" | grep -Ev '^$' | while read tool; do
        tool_path="$(echo "$tool" | awk '{print $NF}')"
        tool_name="$(echo "$tool" | awk '{$NF=""; print $0}')"
        if [ -d "/usr/local/$tool_path" ]; then
            printf "%3s. 安装 ${GREEN}$tool_name${BLANK}\n" "$((var++))"
        else
            printf "%3s. 安装 $tool_name\n" "$((var++))"
        fi
    done
    echo && colorRead ${YELLOW} '请选择' panel_choice
    [ -z "$panel_choice" ] && clear && exit 0
    for J in $panel_choice; do
        install_tool $(echo -e "$tools" | sed -n "${J}p" | awk '{print $NF}')
    done
}

panel
