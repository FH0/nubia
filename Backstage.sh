#!/bin/bash
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

color_print() {
    awk '
    function red_exit(output) {
        output = escape_string(output)
        printf("%s%s%s", colors["red"], output, colors["no_color"])
        exit 1
    }

    # parameters are local variables
    function escape_string(input, i, c, output) {
        output = ""

        for(;;) {
            i = match(input, /\\/)
            if(i == 0) {
                break
            }

            output = output substr(input, 0, i - 1)

            c = substr(input, i + 1, 1)
            if(c == "a") {
                output = output "\a"
            } else if (c == "b") {
                output = output "\b"
            } else if (c == "f") {
                output = output "\f"
            } else if (c == "n") {
                output = output "\n"
            } else if (c == "r") {
                output = output "\r"
            } else if (c == "t") {
                output = output "\t"
            } else if (c == "v") {
                output = output "\v"
            } else {
                output = output c
            }

            input = substr(input, i + 2)
        }
        output = output input

        return output
    }

    BEGIN {
        colors["no_color"] = "\033[0m"
        colors["black"] = "\033[0;30m"
        colors["red"] = "\033[0;31m"
        colors["green"] = "\033[0;32m"
        colors["orange"] = "\033[0;33m"
        colors["blue"] = "\033[0;34m"
        colors["purple"] = "\033[0;35m"
        colors["cyan"] = "\033[0;36m"
        colors["light_gray"] = "\033[0;37m"
        colors["dark_gray"] = "\033[1;30m"
        colors["light_red"] = "\033[1;31m"
        colors["light_green"] = "\033[1;32m"
        colors["yellow"] = "\033[1;33m"
        colors["light_blue"] = "\033[1;34m"
        colors["light_purple"] = "\033[1;35m"
        colors["light_cyan"] = "\033[1;36m"
        colors["white"] = "\033[1;37m"

        if(ARGC < 3 || ARGC % 2 == 0) {
            red_exit("The number of parameters must be no less than 3 and an odd number.\n")
        }

        for(i = 1; i < ARGC; i += 2) {
            color = ARGV[i]
            output = ARGV[i + 1]

            # default no_color
            if (color == "") {
                color = "no_color"
            }

            # check color exists
            if(!(color in colors)) {
                red_exit("invalid color: " color "\n")
            }

            # color print
            output = escape_string(output)
            printf("%s%s%s", colors[color], output, colors["no_color"])
        }

        exit 0
    }' "$@"
}

color_println() {
    color_print "$@\n"
}

color_read() {
    color=$1
    output="$2"
    varaible="$3"

    color_print "$color" "$output: "
    if echo "$SHELL" | grep -q "bash"; then
        read -e $varaible </dev/tty
    else
        read $varaible </dev/tty
    fi
}

package_need() {
    if !command -v apt >/dev/null 2>&1; then
        color_println "red" "请先安装 $package"
        exit 1
    fi
    if dpkg -l $@ >/dev/null 2>&1; then
        return 0
    fi
    apt update
    apt install $@ -y
}

install_tool() {
    key="$1"
    if [ -d "/usr" -a ! -z "$(command -v apt-get yum)" ]; then
        wp="/usr/local/$key"
    else
        color_println "yellow" "请输入安装目录，例如：/usr/local，不能是/bin " wp
        [ -z "$wp" ] && exit 1
        wp=$(echo "$wp/$key" | sed 's|///*|/|g') # 连续的 / 变为一个
    fi
    file="$key.tar"
    if [ -d "$wp" ]; then
        color_println "cyan" "正在卸载 $key ..."
        bash $wp/uninstall.sh >/dev/null 2>&1
    fi
    color_println "cyan" "正在安装 $key 到 $wp ..."
    rm -rf $wp
    mkdir -p $wp
    curl -L "https://raw.githubusercontent.com/FH0/nubia/master/linux-tools/$file" |
        tar -C $wp -xf-
    sed -i "s|^wp=.*|wp=\"$wp\"|g" $wp/*.sh # 修改路径
    bash $wp/install.sh
}

check_environment() {
    if [ "${EUID:-$(id -u)}" != "0" ]; then
        color_println "red" "请切换到 root 用户后再执行此脚本！"
        exit 1
    fi

    if [ "$(uname -r | awk -F '.' '{print $1}')" -lt "3" ]; then
        color_println "red" "内核不支持，请升级内核或更新系统！"
        exit 1
    fi
}

tools_add() {
    tools="$tools$1 $2\n"
}

panel() {
    clear

    check_environment
    package_need tar net-tools

    for tool in $(curl -L "http://github.com/FH0/nubia/tree/master/linux-tools" | grep -Eo '[0-9a-zA-Z_-]+\.tar' | sort -u | sed 's|\.tar||g'); do
        tools_add "$tool" "$tool"
    done

    color_println "cyan" "欢迎使用 JZDH 集合脚本"
    var=1
    echo -e "$tools" | grep -Ev '^$' | while read tool; do
        tool_path="$(echo "$tool" | awk '{print $NF}')"
        tool_name="$(echo "$tool" | awk '{$NF=""; print $0}')"
        if [ -d "/usr/local/$tool_path" ]; then
            color_println "no_color" " $((var++)). 安装 " "green" "$tool_name"
        else
            color_println "no_color" " $((var++)). 安装 " "no_color" "$tool_name"
        fi
    done
    echo && color_read "yellow" '请选择' panel_choice
    [ -z "$panel_choice" ] && clear && exit 0
    for J in $panel_choice; do
        install_tool $(echo -e "$tools" | sed -n "${J}p" | awk '{print $NF}')
    done
}

panel
