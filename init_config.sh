#!/bin/bash
# 开启错误检测，任何命令失败则退出脚本
echo "激活 conda 环境 'dxt'..."
conda activate dxt
git config --global user.name "maverick"
git config --global user.email "maverick6313@gmail.com"
# ----------------------------
# 4. 克隆并安装 pecos 项目
# ----------------------------
echo "进入 /workspace/ 目录并克隆 pecos..."
cd /workspace/
git clone https://github.com/amzn/pecos

echo "进入 pecos 目录并安装项目（editable 模式）..."
cd pecos

apt-get install gcc g++ btop nvtop -y

python3 -m pip install --use-pep517 --editable ./ 


# ----------------------------
# 5. 克隆 xr_tran 项目并执行数据脚本
# ----------------------------
echo "返回 /workspace/ 并克隆 xr_tran 项目..."
cd /workspace/
git clone https://github.com/CountyRipper/xr_tran.git


echo "进入 xr_tran 目录，执行数据脚本..."
cd xr_tran
echo "install requirements.txt"
pip install -r requirements.txt
bash data.sh
bash data.sh wiki10-31k
bash data.sh amazoncat-13k

echo "初始化工作完成！"