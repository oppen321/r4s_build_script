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

# ikoolproxy
git clone --depth=1 https://github.com/ilxp/luci-app-ikoolproxy package/new/luci-app-ikoolproxy

# AdguardGome
rm -rf feeds/packages/net/adguardhome
git_sparse_clone master https://github.com/kenzok8/openwrt-packages adguardhome luci-app-adguardhome luci-app-store luci-lib-taskd taskd luci-lib-xterm

# 一键配置拨号
git clone --depth=1 https://github.com/sirpdboy/luci-app-netwizard package/new/luci-app-netwizard

# SmaerDns
rm -rf feeds/packages/net/smartdns
rm -rf feeds/luci/applications/luci-app-smartdns
git clone --depth=1 https://github.com/pymumu/luci-app-smartdns package/new/luci-app-smartdns
git clone --depth=1 https://github.com/pymumu/openwrt-smartdns package/new/smartdns

# 加入自定义插件
(
  # 等待 .config 文件被创建
  while [ ! -f .config ]; do
      sleep 1  # 每秒检查一次
  done

  # 等待 .config 文件有内容（curl 命令完成下载）
  while [ ! -s .config ]; do
      sleep 1
  done

  # 追加自定义配置
  cat << EOF >> .config
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

# 自动挂载
CONFIG_PACKAGE_luci-app-partexp=y

# iStore商店
CONFIG_PACKAGE_luci-app-store=y

# Lucky
CONFIG_PACKAGE_luci-app-lucky=y

# Lucky核心
CONFIG_PACKAGE_lucky=y

# 一键配置拨号
CONFIG_PACKAGE_luci-app-netwizard=y

# SmaerDns
CONFIG_PACKAGE_luci-app-smartdns=y

# SSR-PLUS
CONFIG_PACKAGE_luci-app-ssr-plus=y
CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_Hysteria=y
CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_IPT2Socks=y
CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_Kcptun=y
CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_NaiveProxy=y
CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_Redsocks2=y
CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_Shadow_TLS=y
# CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_Shadowsocks_Libev_Server is not set
CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_Shadowsocks_Rust_Server=y
CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_Trojan=y
CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_Tuic_Client=y

# Dae
CONFIG_PACKAGE_luci-app-daed=y

# passwall2
luci-app-passwall2
EOF

  echo "自定义配置已成功追加到 .config 文件中"
) &

# 位置修改
sed -i 's/\("admin"\), *\("netwizard"\)/\1, "system", \2/g' package/new/luci-app-netwizard/luasrc/controller/*.lua
