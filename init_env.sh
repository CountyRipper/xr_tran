#!/bin/bash
# 开启错误检测，任何命令失败则退出脚本
set -e
# ----------------------------
# 1. Conda 初始化
# ----------------------------
# 初始化 conda（如果尚未在当前 shell 中初始化）
conda init bash

# 为确保能正常使用 conda 命令，加载 conda 环境脚本
eval "$(conda shell.bash hook)"
source ~/.bashrc
# ----------------------------
# 3. 创建 conda 环境并激活
# ----------------------------
echo "正在创建 conda 环境 'dxt'（Python 3.8）..."
conda create -n dxt python=3.8 -y

source ~/.bashrc
