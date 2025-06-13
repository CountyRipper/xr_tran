#!/bin/bash

set -e  # 出错即退出
echo "✅ 开始初始化云主机环境..."

# ----------------------------
# 1. 安装 Python 3.10
# ----------------------------
echo "🐍 安装 Python 3.10..."

sudo apt-get update
sudo apt-get install -y software-properties-common
sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt-get update
sudo apt-get install -y python3.10 python3.10-venv python3.10-dev python3.10-distutils

echo "🔗 配置 Python 3.10 为默认版本..."

# 替换系统 python3 和 python 的符号链接
sudo update-alternatives --install /usr/bin/python python /usr/bin/python3.10 1
sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.10 1
sudo update-alternatives --set python /usr/bin/python3.10
sudo update-alternatives --set python3 /usr/bin/python3.10

# 安装 pip（对应 Python 3.10）
curl -sS https://bootstrap.pypa.io/get-pip.py | sudo python3.10

echo "✅ Python 3.10 安装完成，并设置为默认版本。"
python --version
pip --version

# ----------------------------
# 2. 克隆并安装 PECOS
# ----------------------------

echo "📁 进入 /workspace/ 并克隆 PECOS..."
cd /workspace/
git clone https://github.com/amzn/pecos
cd pecos

echo "🛠 安装编译工具和监控工具..."
sudo apt-get update && sudo apt-get install -y gcc g++ btop nvtop nvitop

echo "📦 安装 PECOS（--editable 模式）..."
python3 -m pip install --upgrade pip setuptools
python3 -m pip install --use-pep517 --editable ./

echo "🧩 检查 libstdc++ 兼容问题..."
sudo apt install libstdc++6

# ----------------------------
# 3. 克隆 xr_tran 并运行数据处理脚本
# ----------------------------

echo "📁 返回 /workspace/ 并克隆 xr_tran 项目..."
cd /workspace/
git clone https://github.com/CountyRipper/xr_tran.git
cd xr_tran

echo "📦 安装 Python 依赖...,使用新版requirements_d.txt"
pip install -r requirements_d.txt

#echo "📊 运行数据预处理脚本 (eurlex-4k)..."
#bash data.sh eurlex-4k

echo "🎉 初始化工作完成！"