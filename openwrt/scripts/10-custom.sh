#!/bin/bash

# 自定义脚本

# 个性化修改
sed -i "s/hostname='.*'/hostname='ZeroWrt'/g" package/base-files/files/bin/config_generate
curl -s https://raw.githubusercontent.com/oppen321/Diy/refs/heads/main/bg.webp -o package/new/luci-theme-argon/luci-theme-argon/htdocsluci-static/argon/img/bg.webp
curl -s https://raw.githubusercontent.com/oppen321/Diy/refs/heads/main/banner -o package/base-files/files/etc/banner

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
#CONFIG_PACKAGE_luci-app-linkease=y

" >> .config
