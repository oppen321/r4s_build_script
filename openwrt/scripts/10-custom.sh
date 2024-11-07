#!/bin/bash

# 自定义脚本

echo "
# luci-app-mihomo
CONFIG_PACKAGE_luci-app-mihomo=y

# mihomo
CONFIG_PACKAGE_mihomo=y

# Openclash
CONFIG_PACKAGE_luci-app-openclash=y

# AdguardHome
CONFIG_PACKAGE_luci-app-adguardhome=y

# 易有云
#CONFIG_PACKAGE_luci-app-linkease=y

" >> .config
