# ubuntu 20.04 更换阿里云源
cp /etc/apt/sources.list /etc/apt/sources.list.default
echo 'deb http://mirrors.163.com/ubuntu/ focal main restricted universe multiverse
deb-src http://mirrors.163.com/ubuntu/ focal main restricted universe multiverse

deb http://mirrors.163.com/ubuntu/ focal-security main restricted universe multiverse
deb-src http://mirrors.163.com/ubuntu/ focal-security main restricted universe multiverse

deb http://mirrors.163.com/ubuntu/ focal-updates main restricted universe multiverse
deb-src http://mirrors.163.com/ubuntu/ focal-updates main restricted universe multiverse

deb http://mirrors.163.com/ubuntu/ focal-proposed main restricted universe multiverse
deb-src http://mirrors.163.com/ubuntu/ focal-proposed main restricted universe multiverse

deb http://mirrors.163.com/ubuntu/ focal-backports main restricted universe multiverse
deb-src http://mirrors.163.com/ubuntu/ focal-backports main restricted universe multiverse
' >/etc/apt/sources.list

# java
sed -i '/JAVA_HOME/d' ~/.bashrc
echo 'export JAVA_HOME="/usr/local/jdk-11" PATH="$PATH:/usr/local/jdk-11/bin"' >>~/.bashrc
. ~/.bashrc
rm -rf $JAVA_HOME
curl -L "https://download.java.net/openjdk/jdk11/ri/openjdk-11+28_linux-x64_bin.tar.gz" | tar xz -C "/usr/local"

# Hadoop2
sed -i '/HADOOP_HOME/d' ~/.bashrc
echo 'export HADOOP_HOME=/usr/local/hadoop-2.10.2' >>~/.bashrc
echo 'export HADOOP_INSTALL=$HADOOP_HOME' >>~/.bashrc
echo 'export HADOOP_MAPRED_HOME=$HADOOP_HOME' >>~/.bashrc
echo 'export HADOOP_COMMON_HOME=$HADOOP_HOME' >>~/.bashrc
echo 'export HADOOP_HDFS_HOME=$HADOOP_HOME' >>~/.bashrc
echo 'export YARN_HOME=$HADOOP_HOME' >>~/.bashrc
echo 'export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native' >>~/.bashrc
echo 'export PATH=$PATH:$HADOOP_HOME/sbin:$HADOOP_HOME/bin' >>~/.bashrc
. ~/.bashrc
rm -rf $HADOOP_HOME
curl -L "https://dlcdn.apache.org/hadoop/common/hadoop-2.10.2/hadoop-2.10.2.tar.gz" | tar xz -C "/usr/local"

# spark
curl -L "https://dlcdn.apache.org/spark/spark-3.3.0/spark-3.3.0-bin-hadoop3.tgz" | tar xz -C "/usr/local"

# maven
sed -i '/MAVEN_HOME/d' ~/.bashrc
echo 'export MAVEN_HOME="/usr/local/apache-maven-3.8.2" PATH="$PATH:/usr/local/apache-maven-3.8.2/bin"' >>~/.bashrc
. ~/.bashrc
rm -rf $MAVEN_HOME
curl -L "https://dlcdn.apache.org/maven/maven-3/3.8.2/binaries/apache-maven-3.8.2-bin.tar.gz" | tar xz -C "/usr/local"

# mysql
sed -i '/MYSQL_HOME/d' ~/.bashrc
echo 'export MYSQL_HOME="/usr/local/mysql" PATH="$PATH:/usr/local/mysql/bin"' >>~/.bashrc
. ~/.bashrc
rm -rf $MYSQL_HOME
curl -L "https://dev.mysql.com/get/Downloads/MySQL-8.0/mysql-8.0.26-linux-glibc2.17-x86_64-minimal-rebuild.tar.xz" | tar xJ -C "/usr/local"
mv /usr/local/mysql-8.0.26-linux-glibc2.17-x86_64-minimal-rebuild/ $MYSQL_HOME
apt install libncurses5 -y
groupadd mysql
useradd -r -g mysql -s /bin/false mysql
mkdir mysql-files
chown mysql:mysql mysql-files
chmod 750 mysql-files
mysqld --initialize --user=mysql
mysql_ssl_rsa_setup
cp support-files/mysql.server /etc/init.d/mysql.server
## change password
mysqld_safe --skip-grant-tables --skip-networking --user=mysql >/dev/null 2>&1 &
# FLUSH PRIVILEGES;
# ALTER USER 'root'@'localhost' IDENTIFIED BY 'hjuhWRfduHhpZ5NW';
## create test database
# create database test;
# use test;
# \q
pkill mysql*
service mysql.server start

# ruby
gpg2 --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
curl -sSL https://get.rvm.io | bash -s stable
rvm install 3.0.0
rvm use 3.0.0 --default

# rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup target add aarch64-unknown-linux-musl \
    arm-unknown-linux-musleabi \
    mipsel-unknown-linux-musl \
    mips-unknown-linux-musl \
    mips64el-unknown-linux-muslabi64 \
    mips64-unknown-linux-muslabi64 \
    x86_64-unknown-linux-musl \
    i686-unknown-linux-musl \
    x86_64-pc-windows-gnu \
    i686-pc-windows-gnu \
    armv7-linux-androideabi \
    aarch64-linux-android
echo '[build]
target = "x86_64-unknown-linux-musl"
rustflags = [
        "-C", "link-arg=-static",
        "-C", "link-arg=-s",
        "-C", "target-feature=+crt-static",
]


[target.i686-pc-windows-gnu]
linker = "i686-w64-mingw32-gcc"
rustflags = [
        "-C", "panic=abort",
]

[target.x86_64-pc-windows-gnu]
linker = "x86_64-w64-mingw32-gcc"



[target.mipsel-unknown-linux-gnu]
linker = "mipsel-linux-gnu-gcc"

[target.mips-unknown-linux-gnu]
linker = "mips-linux-gnu-gcc"

[target.mips64el-unknown-linux-gnuabi64]
linker = "mips64el-linux-gnuabi64-gcc"

[target.mips64-unknown-linux-gnuabi64]
linker = "mips64-linux-gnuabi64-gcc"

[target.aarch64-unknown-linux-gnu]
linker = "aarch64-linux-gnu-gcc"

[target.arm-unknown-linux-gnueabi]
linker = "arm-linux-gnueabi-gcc"

[target.x86_64-unknown-linux-gnu]
linker = "x86_64-linux-gnu-gcc"

[target.i686-unknown-linux-gnu]
linker = "i686-linux-gnu-gcc"



[target.mipsel-unknown-linux-musl]
linker = "mipsel-linux-musl-gcc"

[target.mips-unknown-linux-musl]
linker = "mips-linux-musl-gcc"

[target.mips64el-unknown-linux-muslabi64]
linker = "mips64el-linux-musl-gcc"

[target.mips64-unknown-linux-muslabi64]
linker = "mips64-linux-musl-gcc"

[target.arm-unknown-linux-musleabi]
linker = "arm-linux-musleabi-gcc"

[target.aarch64-unknown-linux-musl]
linker = "aarch64-linux-musl-gcc"

[target.x86_64-unknown-linux-musl]
linker = "x86_64-linux-musl-gcc"

[target.i686-unknown-linux-musl]
linker = "i686-linux-musl-gcc"



[target.armv7-linux-androideabi]
linker = "arm-linux-androideabi-gcc"
rustflags = [
        "-C", "link-arg=-s",
        "-C", "link-arg=-pthread"
]

[target.aarch64-linux-android]
linker = "aarch64-linux-android-gcc"
rustflags = [
        "-C", "link-arg=-s",
        "-C", "link-arg=-pthread"
]' >~/.cargo/config

# android ndk   https://github.com/android/ndk/issues/1390#issuecomment-740154546
sed -i '/ANDROID_NDK_HOME/d' ~/.bashrc
echo 'export ANDROID_NDK_HOME="/usr/local/android-ndk-r23" PATH="$PATH:/usr/local/android-ndk-r23:/usr/local/android-ndk-r23/toolchains/llvm/prebuilt/linux-x86_64/bin"' >>~/.bashrc
. ~/.bashrc
rm -rf $ANDROID_NDK_HOME
curl -O "https://dl.google.com/android/repository/android-ndk-r23-linux.zip"
bsdtar -C "/usr/local" -xf android-ndk-r23-linux.zip
rm -f android-ndk-r23-linux.zip
## soft link toolchain standalone
for target in aarch64-linux-android armv7a-linux-androideabi i686-linux-android x86_64-linux-android; do
    TOOLCHAIN=$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/linux-x86_64
    for llvm_tool in $(ls $TOOLCHAIN/bin/llvm-* | awk -F 'llvm-' '{print $2}'); do
        ln -sf $TOOLCHAIN/bin/llvm-$llvm_tool $TOOLCHAIN/bin/$target-$llvm_tool
    done
    ln -sf $TOOLCHAIN/bin/llvm-ar $TOOLCHAIN/bin/$target-ar
    ln -sf $TOOLCHAIN/bin/${target}31-clang $TOOLCHAIN/bin/$target-gcc
    ln -sf $TOOLCHAIN/bin/${target}31-clang $TOOLCHAIN/bin/$target-as
    ln -sf $TOOLCHAIN/bin/${target}31-clang++ $TOOLCHAIN/bin/$target-g++
    ln -sf $TOOLCHAIN/bin/ld $TOOLCHAIN/bin/$target-ld
done
## add empty libpthread librt
for path in $(find $ANDROID_NDK_HOME -name libc.so -exec dirname {} \;); do
    touch $path/libpthread.so
    touch $path/libpthread.a
    touch $path/librt.so
    touch $path/librt.a
done

# golang
version=$(curl https://go.dev/dl/ | grep -m1 -Eo "go[.0-9]+linux-amd64.tar.gz")
rm -rf /usr/local/go
curl -L "https://dl.google.com/go/$version" | tar xz -C "/usr/local"
sed -i '/GOROOT/d' ~/.bashrc
echo 'export GOROOT="/usr/local/go" PATH="$PATH:/usr/local/go/bin:'$HOME'/go/bin" GOPATH="'$HOME'/go" GOBIN="'$HOME'/go/bin"' >>~/.bashrc
. ~/.bashrc
mkdir -p $GOPATH/src $GOPATH/pkg $GOPATH/bin

#install openwrt-mips-sdk
curl -L "https://www.pangubox.com/pandorabox/19.01/targets/ralink/mt7620/PandoraBox-SDK-ralink-mt7620_gcc-5.5.0_uClibc-1.0.x.Linux-x86_64-2018-12-31-git-4b6a3d5ca.tar.xz" | tar xJ
mv PandoraBox-SDK-ralink-mt7620_gcc-5.5.0_uClibc-1.0.x.Linux-x86_64-2018-12-31-git-4b6a3d5ca /usr/local/openwrt-mips
export PATH="$PATH:/usr/local/openwrt-mips/staging_dir/toolchain-mipsel_24kec+dsp_gcc-5.5.0_uClibc-1.0.x/bin"
echo 'export PATH="$PATH:/usr/local/openwrt-mips/staging_dir/toolchain-mipsel_24kec+dsp_gcc-5.5.0_uClibc-1.0.x/bin"' >>~/.bashrc

#musl toolchain
for chain in x86_64-linux-musl-native i686-linux-musl-native mipsel-linux-musl-cross mips-linux-musl-cross mips64el-linux-musl-cross mips64-linux-musl-cross aarch64-linux-musl-cross arm-linux-musleabi-cross; do
    curl -O "http://musl.cc/$chain.tgz"
    rm -rf /usr/local/$chain
    tar xf $chain.tgz -C /usr/local
    rm -f $chain.tgz

    sed -i "/$chain/d" ~/.bashrc
    echo "export PATH=\$PATH:/usr/local/$chain/bin" >>~/.bashrc
    . ~/.bashrc
done

# libressl 与 openssl 的兼容性不好
# curl -L "https://github.com/libressl-portable/portable/archive/refs/tags/v3.3.3.tar.gz" | tar xz
# cd portable-3.3.3
# ./autogen.sh
# ## build
# for host in armv7a-linux-androideabi \
#     aarch64-linux-android \
#     i686-linux-gnu \
#     x86_64-linux-gnu; do
#     ./configure --host $host --disable-shared --prefix=/usr/local/cross-compile/$host &&
#         make -j $(nproc) &&
#         make install
#     make clean >/dev/null 2>&1
# done
## clean
rm -rf $(pwd)
cd ..

# boringssl
git clone https://boringssl.googlesource.com/boringssl
cd boringssl
## build
for host in armv7a-linux-androideabi \
    aarch64-linux-android \
    i686-linux-gnu \
    x86_64-linux-gnu; do
    rm -f CMakeCache.txt
    cmake -DCMAKE_SYSTEM_PROCESSOR=${host%%-*} \
        -DCMAKE_SYSTEM_NAME=Linux \
        -DCMAKE_C_COMPILER=$host-gcc \
        -DCMAKE_CXX_COMPILER=$host-g++ \
        -DCMAKE_INSTALL_PREFIX=/usr/local/cross-compile/$host . &&
        make crypto ssl -j $(nproc) &&
        cp -rf ./include/openssl/ /usr/local/cross-compile/$host/include/ &&
        cp -f ./ssl/libssl.a ./crypto/libcrypto.a /usr/local/cross-compile/$host/lib/
    make clean >/dev/null 2>&1
done
## clean
rm -rf $(pwd)
cd ..

# lzo
curl -L "http://www.oberhumer.com/opensource/lzo/download/lzo-2.10.tar.gz" | tar xz
cd lzo-2.10
## build
for host in armv7a-linux-androideabi \
    aarch64-linux-android \
    i686-linux-gnu \
    x86_64-linux-gnu; do
    ./configure --host $host --disable-shared --prefix=/usr/local/cross-compile/$host &&
        make -j $(nproc) &&
        make install
    make clean >/dev/null 2>&1
done
## clean
rm -rf $(pwd)
cd ..

# lz4
curl -L "https://github.com/lz4/lz4/archive/v1.9.2.tar.gz" | tar xz
cd lz4-1.9.2
## build
for host in armv7a-linux-androideabi \
    aarch64-linux-android \
    i686-linux-gnu \
    x86_64-linux-gnu; do
    make CC=$host-gcc -j $(nproc) &&
        make install PREFIX=/usr/local/cross-compile/$host
    make clean >/dev/null 2>&1
done
## clean
rm -rf $(pwd)
cd ..

# pkcs11-helper
curl -L "https://github.com/OpenSC/pkcs11-helper/releases/download/pkcs11-helper-1.27/pkcs11-helper-1.27.0.tar.bz2" | tar xj
cd pkcs11-helper-1.27.0
## build
for host in armv7a-linux-androideabi \
    aarch64-linux-android \
    i686-linux-gnu \
    x86_64-linux-gnu; do
    ./configure --host $host --disable-shared --prefix=/usr/local/cross-compile/$host \
        CFLAGS="-I/usr/local/cross-compile/$host/include" \
        LDFLAGS="-L/usr/local/cross-compile/$host/lib" &&
        make -j $(nproc) &&
        make install
    make clean >/dev/null 2>&1
done
## clean
rm -rf $(pwd)
cd ..

# openvpn
git clone https://github.com/OpenVPN/openvpn.git
cd openvpn
## build
for host in armv7a-linux-androideabi \
    aarch64-linux-android \
    i686-linux-gnu \
    x86_64-linux-gnu; do
    ./configure --host $host --prefix=/usr/local/cross-compile/$host \
        --disable-shared --enable-lzo --enable-pkcs11 \
        --disable-plugin-auth-pam --disable-plugin-down-root --disable-unit-tests \
        CFLAGS="-I/usr/local/cross-compile/$host/include" \
        LDFLAGS="-L/usr/local/cross-compile/$host/lib" \
        PKG_CONFIG_LIBDIR="/usr/local/cross-compile/$host/lib/pkgconfig" &&
        make LIBS='-all-static' -j $(nproc) &&
        make install-strip
    make clean >/dev/null 2>&1
done
## clean
rm -rf $(pwd)
cd ..

# pcre
curl -L "https://ftp.pcre.org/pub/pcre/pcre-8.43.tar.gz" | tar xz
cd pcre-8.43
## build
for host in armv7a-linux-androideabi \
    aarch64-linux-android \
    i686-linux-gnu \
    x86_64-linux-gnu; do
    ./configure --host $host --disable-shared --prefix=/usr/local/cross-compile/$host CFLAGS='-fPIC' &&
        make -j $(nproc) &&
        make install
    make clean >/dev/null 2>&1
done
## clean
rm -rf $(pwd)
cd ..

# zlib
curl -L "https://zlib.net/fossils/zlib-1.2.11.tar.gz" | tar xz
cd zlib-1.2.11
## build
for host in armv7a-linux-androideabi \
    aarch64-linux-android \
    i686-linux-gnu \
    x86_64-linux-gnu; do
    CC=$host-gcc AR=$host-ar RANLIB=$host-ranlib CFLAGS='-fPIC' \
        ./configure --static --prefix=/usr/local/cross-compile/$host &&
        make -j $(nproc) &&
        make install
    make clean >/dev/null 2>&1
done
## clean
rm -rf $(pwd)
cd ..

# lighttpd
curl -L "https://download.lighttpd.net/lighttpd/releases-1.4.x/lighttpd-1.4.59.tar.gz" | tar xz
cd lighttpd-1.4.59
./autogen.sh
## edit
sed -i 's|ifdef _DIRENT_HAVE_D_TYPE|ifdef _ABCD_DIRENT_HAVE_D_TYPE|g' ./src/mod_webdav.c
mods=$(sed -n '/^do_build=/,/^"/p' ./configure | perl -ne 'print "$1\n" while /(mod_\w+)/g')
check_mods=$(perl -e 'undef $/; while(<>){ print $1 if /lighttpd_SOURCES(.*?)lighttpd_CPPFLAGS/s; }' src/Makefile.am)
echo -n '' >src/plugin-static.h
for mod in $mods; do
    echo "PLUGIN_INIT($mod)" >>src/plugin-static.h
    if ! echo "$check_mods" | grep -q $mod; then
        sed -i "s|^lighttpd_SOURCES =|lighttpd_SOURCES = $mod.c|" src/Makefile.am
    fi
done
## build
for host in armv7a-linux-androideabi \
    aarch64-linux-android \
    i686-linux-gnu \
    x86_64-linux-gnu; do
    LIGHTTPD_STATIC=yes CPPFLAGS=-DLIGHTTPD_STATIC ./configure --host=$host --prefix=/usr/local/cross-compile/$host --disable-shared \
        CFLAGS="-I/usr/local/cross-compile/$host/include" \
        LDFLAGS="-L/usr/local/cross-compile/$host/lib" \
        --with-openssl --with-zlib &&
        make LIBS='-ldl -all-static' -j $(nproc) &&
        make install-strip
    make clean >/dev/null 2>&1
done
## clean
rm -rf $(pwd)
cd ..

# apache
ac_cv_file__dev_zero=yes \
    ac_cv_func_setpgrp_void=yes \
    apr_cv_process_shared_works=yes \
    apr_cv_mutex_robust_shared=yes \
    apr_cv_tcp_nodelay_with_cork=yes \
    ap_cv_void_ptr_lt_long=no

# libxml2
curl -L "http://xmlsoft.org/download/libxml2-2.9.12.tar.gz" | tar xz
cd libxml2-2.9.12
## build
for host in armv7a-linux-androideabi \
    aarch64-linux-android \
    i686-linux-gnu \
    x86_64-linux-gnu; do
    ./configure --host=$host --prefix=/usr/local/cross-compile/$host --disable-shared --without-lzma --without-python \
        CFLAGS="-I/usr/local/cross-compile/$host/include" \
        LDFLAGS="-L/usr/local/cross-compile/$host/lib" &&
        make -j $(nproc) &&
        make install
    make clean >/dev/null 2>&1
done
## clean
rm -rf $(pwd)
cd ..

# sqlite3
curl -L "https://www.sqlite.org/2021/sqlite-autoconf-3360000.tar.gz" | tar xz
cd sqlite-autoconf-3360000
## build
for host in armv7a-linux-androideabi \
    aarch64-linux-android \
    i686-linux-gnu \
    x86_64-linux-gnu; do
    ./configure --host=$host --prefix=/usr/local/cross-compile/$host --disable-shared \
        CFLAGS="-I/usr/local/cross-compile/$host/include" \
        LDFLAGS="-L/usr/local/cross-compile/$host/lib" &&
        make -j $(nproc) &&
        make install
    make clean >/dev/null 2>&1
done
## clean
rm -rf $(pwd)
cd ..

# php
curl -L "https://www.php.net/distributions/php-7.4.23.tar.gz" | tar xz
cd php-7.4.23
## edit
sed -i 's|getdtablesize()|sysconf(_SC_OPEN_MAX)|g' ./ext/standard/php_fopen_wrapper.c
## build
for host in armv7a-linux-androideabi \
    aarch64-linux-android \
    i686-linux-gnu \
    x86_64-linux-gnu; do
    ./configure --host=$host --prefix=/usr/local/cross-compile/$host \
        --disable-shared --disable-phpdbg --disable-cgi \
        --with-openssl --with-zlib --with-pcre-jit --enable-bcmath --enable-calendar --enable-mbstring \
        CFLAGS="-I/usr/local/cross-compile/$host/include" \
        LDFLAGS="-L/usr/local/cross-compile/$host/lib" &&
        sed -i "s|/usr/include|/usr/local/cross-compile/$host/include|g" ./Makefile &&
        make LDFLAGS="-L/usr/local/cross-compile/$host/lib -ldl -all-static" -j $(nproc)
    $host-strip sapi/cli/php &&
        mv sapi/cli/php /usr/local/cross-compile/$host/bin
    make clean >/dev/null 2>&1
done
## clean
rm -rf $(pwd)
cd ..

# dnsmasq
curl -L "http://www.thekelleys.org.uk/dnsmasq/dnsmasq-2.85.tar.gz" | tar xz
cd dnsmasq-2.85
## build
for host in armv7a-linux-androideabi \
    aarch64-linux-android \
    i686-linux-gnu \
    x86_64-linux-gnu; do
    LDFLAGS="-static" && echo "$host" | grep -q "android" && LDFLAGS="-llog"
    make CC=$host-gcc CFLAGS="-D__USE_BSD" LDFLAGS="-s $LDFLAGS" -j $(nproc)
    mv src/dnsmasq /usr/local/cross-compile/$host/bin
    make clean >/dev/null 2>&1
done
## clean
rm -rf $(pwd)
cd ..

#android busybox
tar xf github/busybox.tar.gz
cd busybox-1.30.1
make menuconfig -j $(nproc)
make -j $(nproc)
mv busybox ..
cd ..
tar -czf github/busybox.tar.gz busybox-1.30.1
rm -rf busybox-1.30.1

# libevent2
curl -L "https://github.com/libevent/libevent/releases/download/release-2.1.12-stable/libevent-2.1.12-stable.tar.gz" | tar xz
cd libevent-2.1.12-stable
## build
for host in armv7a-linux-androideabi \
    aarch64-linux-android \
    i686-linux-gnu \
    x86_64-linux-gnu; do
    ./configure --host=$host --prefix=/usr/local/cross-compile/$host --disable-shared \
        CFLAGS="-I/usr/local/cross-compile/$host/include" \
        LDFLAGS="-L/usr/local/cross-compile/$host/lib"
    make -j $(nproc) &&
        make install
    make clean >/dev/null 2>&1
done
## clean
rm -rf $(pwd)
cd ..

# redsocks
git clone https://github.com/darkk/redsocks.git
cd redsocks
## build
for host in armv7a-linux-androideabi \
    aarch64-linux-android \
    i686-linux-gnu \
    x86_64-linux-gnu; do
    make CC=$host-gcc -j $(nproc) \
        CFLAGS="-I/usr/local/cross-compile/$host/include" \
        LDFLAGS="-s -static -L/usr/local/cross-compile/$host/lib"
    mv redsocks /usr/local/cross-compile/$host/bin
    make clean >/dev/null 2>&1
done
## clean
rm -rf $(pwd)
cd ..

# pdnsd
curl -L "https://fossies.org/linux/misc/dns/pdnsd-1.2.9a-par.tar.gz" | tar xz
cd pdnsd-1.2.9a
## build
for host in armv7a-linux-androideabi \
    aarch64-linux-android \
    i686-linux-gnu \
    x86_64-linux-gnu; do
    ./configure --host=$host --prefix=/usr/local/cross-compile/$host \
        LDFLAGS='-s -static'
    make -j $(nproc)
    mv src/pdnsd /usr/local/cross-compile/$host/bin
    make clean >/dev/null 2>&1
done
## clean
rm -rf $(pwd)
cd ..

# libssh2
curl -L "https://github.com/libssh2/libssh2/releases/download/libssh2-1.10.0/libssh2-1.10.0.tar.gz" | tar xz
cd libssh2-1.10.0
## build
for host in armv7a-linux-androideabi \
    aarch64-linux-android \
    i686-linux-gnu \
    x86_64-linux-gnu; do
    ./configure --host=$host --prefix=/usr/local/cross-compile/$host --disable-shared --disable-examples-build \
        CFLAGS="-I/usr/local/cross-compile/$host/include" \
        LDFLAGS="-L/usr/local/cross-compile/$host/lib"
    make -j $(nproc) &&
        make install
    make clean >/dev/null 2>&1
done
## clean
rm -rf $(pwd)
cd ..

# libcurl
git clone https://github.com/curl/curl.git
cd curl
## build
autoreconf -fi
for host in armv7a-linux-androideabi \
    aarch64-linux-android \
    i686-linux-gnu \
    x86_64-linux-gnu; do
    ./configure --host=$host --prefix=/usr/local/cross-compile/$host --with-openssl --with-libssh2 --disable-shared \
        CFLAGS="-I/usr/local/cross-compile/$host/include" \
        LDFLAGS="-L/usr/local/cross-compile/$host/lib"
    make -j $(nproc) &&
        make install
    make clean >/dev/null 2>&1
done
## clean
rm -rf $(pwd)
cd ..

# libzip
curl -L "https://github.com/nih-at/libzip/releases/download/v1.8.0/libzip-1.8.0.tar.gz" | tar xz
cd libzip-1.8.0
## build
for host in armv7a-linux-androideabi \
    aarch64-linux-android \
    i686-linux-gnu \
    x86_64-linux-gnu; do
    CC=$host-gcc \
        CFLAGS="-I/usr/local/cross-compile/$host/include" \
        LDFLAGS="-L/usr/local/cross-compile/$host/lib" \
        cmake -DBUILD_SHARED_LIBS=OFF \
        -DCMAKE_INSTALL_PREFIX=/usr/local/cross-compile/$host \
        -DBUILD_TOOLS=OFF \
        -DBUILD_EXAMPLES=OFF .
    make -j $(nproc) &&
        make install
    make clean >/dev/null 2>&1
done
## clean
rm -rf $(pwd)
cd ..

# libonig
curl -L "https://github.com/kkos/oniguruma/releases/download/v6.9.7.1/onig-6.9.7.1.tar.gz" | tar xz
cd onig-6.9.7
## build
for host in armv7a-linux-androideabi \
    aarch64-linux-android \
    i686-linux-gnu \
    x86_64-linux-gnu; do
    ./configure --host=$host --prefix=/usr/local/cross-compile/$host --disable-shared
    make -j $(nproc) &&
        make install
    make clean >/dev/null 2>&1
done
## clean
rm -rf $(pwd)
cd ..

# libuv
curl -L "https://github.com/libuv/libuv/archive/v1.42.0.tar.gz" | tar xz
cd libuv-1.42.0
./autogen.sh
## build
for host in armv7a-linux-androideabi \
    aarch64-linux-android \
    i686-linux-gnu \
    x86_64-linux-gnu; do
    ./configure --host=$host --prefix=/usr/local/cross-compile/$host --disable-shared &&
        make -j $(nproc) &&
        make install
    make clean >/dev/null 2>&1
done
## clean
rm -rf $(pwd)
cd ..

# smartdns
git clone https://github.com/pymumu/smartdns.git
cd smartdns
## build
for host in armv7a-linux-androideabi \
    aarch64-linux-android \
    i686-linux-gnu \
    x86_64-linux-gnu; do
    CFLAGS="-I/usr/local/cross-compile/$host/include" \
        LDFLAGS="-s -static -L/usr/local/cross-compile/$host/lib" \
        ./package/build-pkg.sh \
        --platform linux \
        --arch=$host \
        --cross-tool $host-
    mv ./src/smartdns /usr/local/cross-compile/$host/bin/
done
## clean
rm -rf $(pwd)
cd ..

# zstd
git clone https://github.com/facebook/zstd.git
cd zstd/
## build
for host in armv7a-linux-androideabi \
    aarch64-linux-android \
    i686-linux-gnu \
    x86_64-linux-gnu; do
    CC=$host-gcc \
        CXX=$host-g++ \
        CFLAGS="-I/usr/local/cross-compile/$host/include" \
        LDFLAGS="-L/usr/local/cross-compile/$host/lib" \
        cmake -DCMAKE_INSTALL_PREFIX=/usr/local/cross-compile/$host \
        -DZSTD_BUILD_STATIC=ON \
        -DZSTD_BUILD_SHARED=OFF \
        ./build/cmake/ &&
        make -j $(nproc) &&
        make install
    make clean >/dev/null 2>&1
done
## clean
rm -rf $(pwd)
cd ..

#v2ray 手动构建
https://github.com/golang/go/issues/8877#issuecomment-300937986
sed -i 's|^+||g' /usr/local/go/src/net/dnsconfig_unix.go
rm -rf v2ray-core
git clone https://github.com/v2fly/v2ray-core.git
cd v2ray-core && go mod download
sed -i '220iif strings.Compare(domain, "res.res.res.res") != 0 {' app/dispatcher/default.go
sed -i '224i}' app/dispatcher/default.go
CGO_ENABLED=0 GOOS=linux GOARCH=arm go build -o $HOME/v2ray_arm -trimpath -ldflags "-s -w -buildid=" ./main
CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build -o $HOME/v2ray_arm64 -trimpath -ldflags "-s -w -buildid=" ./main

curl -O 'https://raw.githubusercontent.com/v2ray/geoip/master/main.go'
go build main.go && mv main /bin/geoip

curl -L "https://download.maxmind.com/app/geoip_download?edition_id=GeoLite2-Country-CSV&license_key=JvbzLLx7qBZT&suffix=zip" | bsdtar -xf-
mv GeoLite2* geoip
cd geoip
sed -i '2,$d' GeoLite2-Country-Locations-en.csv
echo '1814991,en,AS,Asia,CN,China,0' >>GeoLite2-Country-Locations-en.csv
sed -i '2,$d' GeoLite2-Country-Blocks-IPv6.csv
awk -F',' '{if($3==1814991){print $0}}' GeoLite2-Country-Blocks-IPv4.csv >a
sed -i '2,$d' GeoLite2-Country-Blocks-IPv4.csv
cat a >>GeoLite2-Country-Blocks-IPv4.csv
geoip --country=GeoLite2-Country-Locations-en.csv --ipv4=GeoLite2-Country-Blocks-IPv4.csv --ipv6=GeoLite2-Country-Blocks-IPv6.csv

#x64 json-c
git clone https://github.com/json-c/json-c.git
cd json-c
## build
for host in armv7a-linux-androideabi \
    aarch64-linux-android \
    i686-linux-gnu \
    x86_64-linux-gnu; do
    CC=$host-gcc \
        cmake \
        -DCMAKE_INSTALL_PREFIX=/usr/local/cross-compile/$host \
        -DBUILD_SHARED_LIBS=OFF . &&
        make -j $(nproc) &&
        make install
    make clean >/dev/null 2>&1
done
## clean
rm -rf $(pwd)
cd ..

# expat
git clone https://github.com/libexpat/libexpat.git
cd libexpat
## build
autoreconf -fi ./expat
for host in armv7a-linux-androideabi \
    aarch64-linux-android \
    i686-linux-gnu \
    x86_64-linux-gnu; do
    ./expat/configure --host=$host --prefix=/usr/local/cross-compile/$host --disable-shared &&
        make -j $(nproc) &&
        make install
    make clean >/dev/null 2>&1
done
## clean
rm -rf $(pwd)
cd ..

# c-ares
git clone https://github.com/c-ares/c-ares.git
cd c-ares
## build
autoreconf -fi
for host in armv7a-linux-androideabi \
    aarch64-linux-android \
    i686-linux-gnu \
    x86_64-linux-gnu; do
    ./configure --host=$host --prefix=/usr/local/cross-compile/$host --disable-shared &&
        make -j $(nproc) &&
        make install
    make clean >/dev/null 2>&1
done
## clean
rm -rf $(pwd)
cd ..

# aria2c
git clone https://github.com/aria2/aria2.git
cd aria2
## build
autoreconf -fi
for host in armv7a-linux-androideabi \
    aarch64-linux-android \
    i686-linux-gnu \
    x86_64-linux-gnu; do
    ./configure --host=$host \
        --prefix=/usr/local/cross-compile/$host \
        --without-libxml2 \
        ARIA2_STATIC=yes \
        CFLAGS="-I/usr/local/cross-compile/$host/include" \
        CXXFLAGS="-I/usr/local/cross-compile/$host/include" \
        LDFLAGS="-s -L/usr/local/cross-compile/$host/lib" &&
        make -j $(nproc) &&
        make install
    make clean >/dev/null 2>&1
done
## clean
rm -rf $(pwd)
cd ..

# LuaJIT
git clone https://github.com/LuaJIT/LuaJIT.git
cd LuaJIT
## build
for host in armv7a-linux-androideabi \
    aarch64-linux-android \
    i686-linux-gnu \
    x86_64-linux-gnu; do
    if
        echo 'void main(){}' | $host-gcc -x c -
        file a.out | grep -q '32-bit'
    then
        HOST_CC=i686-linux-gnu-gcc
    else
        HOST_CC=x86_64-linux-gnu-gcc
    fi
    make HOST_CC=$HOST_CC CROSS=$host- LDFLAGS='-static' BUILDMODE=static -j $(nproc) &&
        make install PREFIX=/usr/local/cross-compile/$host &&
        mv /usr/local/cross-compile/$host/bin/luajit* /usr/local/cross-compile/$host/bin/luajit
    make clean >/dev/null 2>&1
done
## env
sed -i '/LUA_PATH/d' ~/.bashrc
cat >>~/.bashrc <<EOF
# LUA_PATH
export LUA_PATH=/usr/local/cross-compile/x86_64-linux-gnu/share/luajit-2.1.0-beta3/?.lua
EOF
. ~/.bashrc
## clean
rm -rf $(pwd)
cd ..

# wrk
git clone https://github.com/wg/wrk.git
cd wrk
## build
for host in armv7a-linux-androideabi \
    aarch64-linux-android \
    i686-linux-gnu \
    x86_64-linux-gnu; do
    make CC=$host-gcc -j $(nproc) \
        LDFLAGS="-static -L/usr/local/cross-compile/$host/lib" \
        CFLAGS="-I/usr/local/cross-compile/$host/include -I/usr/local/cross-compile/$host/include/luajit-2.1" \
        WITH_LUAJIT=/usr/local/cross-compile/$host \
        WITH_OPENSSL=/usr/local/cross-compile/$host &&
        mv wrk /usr/local/cross-compile/$host/bin
    make clean >/dev/null 2>&1
done
## clean
rm -rf $(pwd)
cd ..

#x64 libmnl
wget "https://netfilter.org/projects/libmnl/files/libmnl-1.0.4.tar.bz2"
tar xf libmnl-1.0.4.tar.bz2
cd libmnl-1.0.4
./configure --enable-static
make install-strip -j $(nproc)
rm -rf $(pwd)
cd ..

#android libmnl
wget "https://netfilter.org/projects/libmnl/files/libmnl-1.0.4.tar.bz2"
tar xf libmnl-1.0.4.tar.bz2
cd libmnl-1.0.4
#arm
./configure --host=arm-linux-androideabi --prefix=/usr/local/cross-compile/android-arm --enable-static
make install-strip -j $(nproc)
make clean >/dev/null 2>&1
#arm64
./configure --host=aarch64-linux-android --prefix=/usr/local/cross-compile/android-arm64 --enable-static
make install-strip -j $(nproc)
rm -rf $(pwd)
cd ..

#x64 wg
git clone git://git.zx2c4.com/wireguard-tools
cd wireguard-tools/src
make LDLIBS='-s -l:libmnl.a' -j $(nproc)
mv wg ../..
cd ../..
rm -rf wireguard-tools

#x64 wget
curl -L "http://ftp.gnu.org/gnu/wget/wget-1.20.3.tar.gz" | tar xz
cd wget-1.20.3
./configure --with-ssl=openssl
make install-strip -j $(nproc)
rm -rf $(pwd)
cd ..

#x64 boost
curl -L "https://boostorg.jfrog.io/artifactory/main/release/1.79.0/source/boost_1_79_0.tar.gz" | tar xz
cd boost_1_79_0
./bootstrap.sh --with-libraries=all --with-toolset=gcc
./b2 toolset=gcc threading=multi
./b2 install
ldconfig
rm -rf $(pwd)
cd ..

#android boost
curl -L "https://boostorg.jfrog.io/artifactory/main/release/1.79.0/source/boost_1_79_0.tar.gz" | tar xz
cd boost_1_79_0
#arm
./bootstrap.sh --with-libraries=all --prefix=/usr/local/cross-compile/android-arm
sed -i 's|using gcc.*|using gcc : : /usr/local/android-arm/bin/arm-linux-androideabi-gcc ;' project-config.jam
./b2 threading=multi
./b2 install
#arm64
./bootstrap.sh --with-libraries=all --prefix=/usr/local/cross-compile/android-arm64
sed -i 's|using gcc.*|using gcc : : /usr/local/android-aarch64/bin/aarch64-linux-android-gcc ;' project-config.jam
./b2 threading=multi
./b2 install
rm -rf $(pwd)
cd ..

#精简 boost
curl -L "https://boostorg.jfrog.io/artifactory/main/release/1.79.0/source/boost_1_79_0.tar.gz" | tar xz
cd boost_1_79_0
./bootstrap.sh
./b2 tools/bcp
mkdir boost_
./dist/bin/bcp boost/asio.hpp boost_
./dist/bin/bcp boost/property_tree/ptree.hpp boost_
./dist/bin/bcp boost/property_tree/json_parser.hpp boost_

#android arm iproute2
curl -L "https://github.com/shemminger/iproute2/archive/v5.1.0.tar.gz" | tar xz
cd iproute2-5.1.0
sed -i 's/SUBDIRS=.*/SUBDIRS=lib ip/' Makefile
make CC=arm-linux-androideabi-gcc LDFLAGS=-s -j4

#asio
curl -L "http://downloads.sourceforge.net/project/asio/asio/1.18.0 (Stable)/asio-1.18.0.tar.gz" | tar xz
cd asio-1.18.0/
./configure --without-boost

# android dropbear ./dropbear -r ./dropbear_rsa_host_key -F -G root -U root -p 0.0.0.0:1122 -a -A -T ./public_key -s
curl -L "https://github.com/mkj/dropbear/archive/DROPBEAR_2018.76.tar.gz" | tar xz
cd dropbear-DROPBEAR_2018.76/
curl -OL "https://raw.githubusercontent.com/ubiquiti/dropbear-android/master/android-compat.patch"
curl -OL "https://raw.githubusercontent.com/ubiquiti/dropbear-android/master/config.guess"
curl -OL "https://raw.githubusercontent.com/ubiquiti/dropbear-android/master/config.sub"
autoreconf
patch -p1 <android-compat.patch
./configure --host=arm-linux-gnueabi --disable-utmp --disable-wtmp --disable-utmpx --disable-zlib --disable-syslog
make LDFLAGS=-static -j $(nproc)
cp dropbear dropbearkey dropbearconvert dbclient ..
arm-linux-gnueabi-strip dropbear dropbearkey dropbearconvert dbclient
rm -rf $(pwd)
cd ..

# wsl2 kernel
git clone https://github.com/microsoft/WSL2-Linux-Kernel.git
cd WSL2-Linux-Kernel
apt install g++ make flex bison libssl-dev libelf-dev bc -y
make KCONFIG_CONFIG=Microsoft/config-wsl menuconfig # 图形化的安装界面，键入 / 进行搜索，NETFILTER_XTABLES
make KCONFIG_CONFIG=Microsoft/config-wsl bzImage -j $(nproc)
cp arch/x86/boot/bzImage ../kernel
rm -rf $(pwd)
cd ..

# openwrt
## 公钥登录
## 宽带
## WIFI
## dnsmasq 并发
## WiFi定时关闭
## ssh内网穿透
## 拨号脚本 + DDNS
## 增加 kmod-mtd-rw
## 增加 luci-app-usb-printer
## 增加 iptables-mod-tproxy
## 增加 kmod-tun
## 增加 ipv6helper
## 去掉 luci-app-nlbwmon PACKAGE_nlbwmon 网络监视器
## 去掉 luci-app-accesscontrol 访问时间控制
## 去掉 luci-app-ddns PACKAGE_ddns-scripts
## 去掉 luci-app-filetransfer luci-lib-fs
## 去掉 luci-app-unblockmusic
## 去掉 luci-app-vlmcsd PACKAGE_vlmcsd KMS服务器
## 去掉 luci-app-vsftpd PACKAGE_vsftpd-alt
## 去掉 opkg
## 去掉 wget-ssl
## 去掉 openssl-util
## bin/targets/ramips/mt7621
## install
opkg update &&
    opkg install nano vim bash tcpdump
## compile
git clone https://github.com/coolsnowwolf/lede.git
chown -R noroot:noroot lede
chown o+x ~
ln -sf ~/lede /home/noroot
su - noroot
cd lede
./scripts/feeds update -a
./scripts/feeds install -a
make menuconfig
make download V=s -j1
make V=s -j $(nproc)

# Padavan
## mtd_write write /tmp/openwrt-ramips-mt7620-phicomm_psg1218a-squashfs-sysupgrade.bin Firmware_Stub
apt install unzip libtool-bin curl cmake gperf gawk flex bison nano xxd \
    fakeroot kmod cpio git python3-docutils gettext automake autopoint \
    texinfo build-essential help2man pkg-config zlib1g-dev libgmp3-dev \
    libmpc-dev libmpfr-dev libncurses5-dev libltdl-dev wget libc-dev-bin -y
git clone https://github.com/hanwckf/rt-n56u.git
chown -R noroot:noroot rt-n56u
chmod o+x ~
ln -sf ~/rt-n56u /home/noroot
su - noroot
cd rt-n56u/toolchain-mipsel
./dl_toolchain.sh
cd ../trunk
fakeroot ./build_firmware_modify PSG1218
# curl -L "http://dynv6.com/api/update?hostname=compile.dynv6.net&token=idfqd8CMak8agnzyqCXwqp19Sihg47&ipv4=auto"

# vim
add-apt-repository ppa:jonathonf/vim
apt update
apt install vim -y
# apt remove vim
# add-apt-repository --remove ppa:jonathonf/vim
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
curl -sL install-node.now.sh/lts | bash
# call plug#begin('~/.vim/plugged')
# Plug 'neoclide/coc.nvim', {'branch': 'release'}
# Plugin 'jiangmiao/auto-pairs'
# call plug#end()
# :PlugUpdate
# set mouse=a
:CocInstall coc-snippets
:CocInstall coc-python
:CocInstall coc-json
:CocInstall coc-rust-analyzer

# nasm
curl -L 'https://www.nasm.us/pub/nasm/releasebuilds/2.00/nasm-2.00.tar.gz' | tar xz
./configure
make -j$(nproc)
make install

# bochs
curl -L 'https://udomain.dl.sourceforge.net/project/bochs/bochs/2.6.8/bochs-2.6.8.tar.gz' | tar xz
cd bochs-2.6.8/
./configure
make -j$(nproc)
make install

# 饥荒自建服务器
dpkg --add-architecture i386 # If running a 64bit OS
apt-get update
apt-get install lib32gcc1 lib32stdc++6 libcurl4-gnutls-dev:i386 -y
mkdir ~/steamcmd
cd ~/steamcmd
curl -L 'https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz' | tar xz
./steamcmd.sh
login anonymous
force_install_dir /root/Steam/steamapps/DST/bin
app_update 343050 validate
quit
cd /root/Steam/steamapps/DST/bin/
screen -S 'Master' ./dontstarve_dedicated_server_nullrenderer -console -cluster Cluster_3 -shard Master
screen -S 'Caves' ./dontstarve_dedicated_server_nullrenderer -console -cluster Cluster_3 -shard Caves

# webrtc native
git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git /usr/local/depot_tools
sed -i '/\/usr\/local\/depot_tools/d' ~/.bashrc
echo 'export PATH=$PATH:/usr/local/depot_tools' >>~/.bashrc
. ~/.bashrc
mkdir webrtc-native
cd webrtc-native
fetch --nohooks webrtc
gclient sync
./src/build/install-build-deps.sh <<EOF
6
70
EOF

set -e
for target in \
    aarch64-linux-gnu.2.28 \
    aarch64-macos \
    x86_64-linux-gnu.2.28; do
    target_cpu=$(echo $target | awk -F '-' '{print $1}')
    if [ "$target_cpu" = "aarch64" ]; then
        target_cpu=arm64
    elif [ "$target_cpu" = "x86_64" ]; then
        target_cpu=x64
    elif [ "$target_cpu" = "i386" ]; then
        target_cpu=x86
    fi
    gn gen out/release-$target --args='
        target_cpu="'$target_cpu'"
        is_debug=false
        treat_warnings_as_errors=false
        use_sysroot=false
        is_clang=true
        use_lld=false
        clang_use_chrome_plugins=false
        is_component_build=false
        enable_libaom=false
        rtc_include_ilbc=false
        rtc_use_x11=false
        rtc_enable_grpc=false
        rtc_include_builtin_video_codecs=false
        rtc_include_builtin_audio_codecs=false
        rtc_include_internal_audio_device=false
        rtc_enable_protobuf=false
        rtc_include_dav1d_in_internal_decoder_factory=false
        rtc_use_h264=false
        rtc_include_tests=false
        rtc_build_tools=false
        rtc_build_examples=false
        use_custom_libcxx=false
        use_rtti=true'
    sed -i 's|../../third_party/llvm-build/Release+Asserts/bin/clang |zig cc -target '$target' -Wno-unknown-warning-option |g' out/release-$target/toolchain.ninja
    sed -i 's|../../third_party/llvm-build/Release+Asserts/bin/clang++ |zig c++ -target '$target' -Wno-unknown-warning-option |g' out/release-$target/toolchain.ninja
    sed -i 's|"../../third_party/llvm-build/Release+Asserts/bin/llvm-ar"|zig ar|g' out/release-$target/toolchain.ninja
    find out/release-$target -name '*.ninja' | xargs sed -i 's|-latomic||g'
    find out/release-$target -name '*.ninja' | xargs sed -i 's|-march=armv[0-9a-zA-Z-]*||g'
    ninja -C out/release-$target -j$(nproc)
done

target_os=linux
target_cpu=arm64
gn clean out/release-$target_os-$target_cpu
gn gen out/release-$target_os-$target_cpu --args='
    target_os="'$target_os'"
    target_cpu="'$target_cpu'"
    is_debug=false
    treat_warnings_as_errors=false
    rtc_use_x11=false
    is_component_build=false
    rtc_include_tests=false
    rtc_build_examples=false
    use_custom_libcxx=false
    use_rtti=true'
ninja -C out/release-$target_os-$target_cpu -j$(nproc)

target_os=linux
target_cpu=arm64
gn clean out/release-$target_os-$target_cpu
gn gen out/release-$target_os-$target_cpu --args='
    target_os="'$target_os'"
    target_cpu="'$target_cpu'"
    is_debug=false
    treat_warnings_as_errors=false
    rtc_use_x11=false
    is_component_build=false
    rtc_include_tests=false
    rtc_build_examples=false
    use_custom_libcxx=false
    use_rtti=true'
ninja -C out/release-$target_os-$target_cpu -j$(nproc)

target_os=linux
target_cpu=x64
gn clean out/release-$target_os-$target_cpu
gn gen out/release-$target_os-$target_cpu --args='
    target_os="'$target_os'"
    target_cpu="'$target_cpu'"
    is_debug=false
    treat_warnings_as_errors=false
    rtc_use_x11=false
    is_component_build=false
    rtc_include_tests=false
    rtc_build_examples=false
    use_custom_libcxx=false
    use_rtti=true'
ninja -C out/release-$target_os-$target_cpu -j$(nproc)

gn gen out/Debug-gcc --args='is_debug=true treat_warnings_as_errors=false rtc_use_x11=false is_component_build=false use_sysroot=false is_clang=false use_lld=false treat_warnings_as_errors=false rtc_include_tests=false rtc_build_examples=false use_custom_libcxx=false use_rtti=true'
ninja -C out/Debug-gcc -j$(nproc)
gn clean out/Release
gn gen out/Release-gcc --args='is_debug=false treat_warnings_as_errors=false rtc_use_x11=false is_component_build=false use_sysroot=false is_clang=false use_lld=false treat_warnings_as_errors=false rtc_include_tests=false rtc_build_examples=false use_custom_libcxx=false use_rtti=true'
ninja -C out/Release-gcc -j$(nproc)
mkdir -p webrtc
# examples abseil-cpp
for header_file in $(find . -name '*.h' | grep -Ev '/build/linux/|examples'); do
    cp --parents $header_file ./webrtc/include -f
done

# clang
apt-get install clang lldb lld clangd libc++-dev libc++1 libc++abi-dev libc++abi1 -y

# zig
sed -i '/\/usr\/local\/zig/d' ~/.bashrc
echo 'export PATH="$PATH:/usr/local/zig"' >>~/.bashrc
. ~/.bashrc
url=$(curl -L 'https://ziglang.org/zh/download/' | grep -Eo '[a-zA-Z0-9.://-]+zig-linux-x86_64-[0-9.]+tar\.xz' | head -n1)
curl -L "$url" | tar xJ -C "/usr/local"
mv /usr/local/zig* /usr/local/zig

# mupdf
git clone https://github.com/ArtifexSoftware/mupdf.git
cd mupdf
make install -j$(nproc)
rm -rf $(pwd)
cd ..

# msquic
apt install build-essential liblttng-ust-dev lttng-tools libnuma-dev -y
git clone --recurse-submodules --depth=1 https://github.com/microsoft/msquic
mkdir msquic/build
cd msquic/build
cmake -DQUIC_BUILD_SHARED=OFF ..
make -j$(nproc)

# cmake
git clone https://github.com/Kitware/CMake.git
cd CMake
./bootstrap
make install -j$(nproc)
rm -rf $(pwd)
cd ..

# git
curl -L 'https://github.com/git/git/archive/refs/tags/v2.39.2.tar.gz' | tar xz
cd git-2.39.2
# yum install -y curl-devel expat-devel gettext-devel openssl-devel zlib-devel
make prefix=/usr install -j$(nproc)
rm -rf $(pwd)
cd ..

# aarch64-linux-gnu-gdb
curl -L "https://ftp.gnu.org/gnu/gdb/gdb-13.1.tar.xz" | tar xJ
cd gdb-13.1
./configure --target=aarch64-linux-gnu --prefix=/usr/local
make -j$(nproc)
make install -j$(nproc)
rm -rf $(pwd)
cd ..

# install quic test tools
apt install python3-pip -y
pip3 install aioquic
pip3 install quicly

cd /chroot
mount --bind /dev dev
mount --bind /dev/pts dev/pts
mount --bind /sys sys
rm -rf tmp && mkdir tmp && mount --bind /tmp tmp
rm -rf run && mkdir run && mount tmpfs run -t tmpfs && mkdir run/{lock,shm}
chroot /chroot
cd
mount -t proc proc /proc

umount dev/pts dev sys tmp run proc
rm -f /tmp/chroot.tgz
tar cvzf /tmp/chroot.tgz .
