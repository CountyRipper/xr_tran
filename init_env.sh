#!/bin/bash

set -e  # 出错即退出
echo "✅ 开始初始化云主机环境..."

# ----------------------------
# 1. 安装 Python 3.8.20（使用 Miniconda 推荐方式）
# ----------------------------

#echo "🧹 删除系统预装 Python（若存在）..."
#sudo apt-get remove -y python3 python3-pip python3-dev || true

echo "📦 下载并安装 Miniconda（用于安装 Python 3.9.20）..."
cd ~
wget -O miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash miniconda.sh -b -p $HOME/miniconda3
rm miniconda.sh
eval "$($HOME/miniconda3/bin/conda shell.bash hook)"
# 持久化到 .bashrc
$HOME/miniconda3/bin/conda init

echo "🐍 创建 Python 3.9 环境: dxt for 5090 pytorch"
conda create -n dxt python=3.9 -y
conda activate dxt

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
conda install -c conda-forge libstdcxx-ng -y

# ----------------------------
# 3. 克隆 xr_tran 并运行数据处理脚本
# ----------------------------

echo "📁 返回 /workspace/ 并克隆 xr_tran 项目..."
cd /workspace/
git clone https://github.com/CountyRipper/xr_tran.git
cd xr_tran

echo "📦 安装 Python 依赖..."
pip install -r requirements.txt

#echo "📊 运行数据预处理脚本 (eurlex-4k)..."
#bash data.sh eurlex-4k

echo "🎉 初始化工作完成！"