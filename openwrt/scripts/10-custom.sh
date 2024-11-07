#!/bin/bash

# 自定义脚本

# 个性化修改
https://raw.githubusercontent.com/oppen321/Diy/refs/heads/main/bg.webp
https://raw.githubusercontent.com/oppen321/Diy/refs/heads/main/banner

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
