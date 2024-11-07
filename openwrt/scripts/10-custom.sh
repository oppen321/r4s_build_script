#!/bin/bash

# 自定义脚本
# 个性化修改
sed -i "s/hostname='.*'/hostname='ZeroWrt'/g" package/base-files/files/bin/config_generate
curl -s https://raw.githubusercontent.com/oppen321/Diy/refs/heads/main/bg.webp -o package/new/luci-theme-argon/luci-theme-argon/htdocs/luci-static/argon/img/bg.webp
curl -s https://raw.githubusercontent.com/oppen321/Diy/refs/heads/main/banner -o package/base-files/files/etc/banner

# Git稀疏克隆，只克隆指定目录到本地
function git_sparse_clone() {
  branch="$1" repourl="$2" && shift 2
  git clone --depth=1 -b $branch --single-branch --filter=blob:none --sparse $repourl
  repodir=$(echo $repourl | awk -F '/' '{print $(NF)}')
  cd $repodir && git sparse-checkout set $@
  mv -f $@ ../package/new
  cd .. && rm -rf $repodir
}

# Lucky
git clone --depth=1 https://github.com/sirpdboy/luci-app-lucky package/new/luci-app-lucky

# luci-app-partexp
git clone --depth=1 https://github.com/sirpdboy/luci-app-partexp package/new/luci-app-partexp

# ChatGpt Web
git clone --depth=1 https://github.com/sirpdboy/chatgpt-web.git package/new/luci-app-chatgpt

# ikoolproxy
git clone --depth=1 https://github.com/ilxp/luci-app-ikoolproxy package/new/luci-app-ikoolproxy

# AdguardGome
git_sparse_clone master https://github.com/kenzok8/openwrt-packages adguardhome luci-app-adguardhome

# 一键配置拨号
git clone --depth=1 https://github.com/sirpdboy/luci-app-netwizard package/new/luci-app-netwizard

# 加入自定义插件
echo "
# luci-app-mihomo
CONFIG_PACKAGE_luci-app-mihomo=y

# mihomo
CONFIG_PACKAGE_mihomo=y

# Openclash
CONFIG_PACKAGE_luci-app-openclash=y

# AdguardHome
CONFIG_PACKAGE_luci-app-adguardhome=y

# AdguardHome核心
CONFIG_PACKAGE_adguardhome=y

# ikoolproxy
CONFIG_PACKAGE_luci-app-ikoolproxy=y

# chatgpt
CONFIG_PACKAGE_luci-app-chatgpt=y

# 自动挂载
CONFIG_PACKAGE_luci-app-partexp=y

# Lucky
CONFIG_PACKAGE_luci-app-lucky=y

# Lucky核心
CONFIG_PACKAGE_lucky=y

# 一键配置拨号
CONFIG_PACKAGE_luci-app-netwizard=y
" >> .config

# 位置修改
sed -i 's/\("admin"\), *\("netwizard"\)/\1, "system", \2/g' package/new/luci-app-netwizard/luasrc/controller/*.lua
