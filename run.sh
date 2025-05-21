#!/bin/bash

data=$1
model_input=$2
data_dir="./xmc-base/${data}/"

# 根据数据集设置默认模型和集成方法
if [ ${data} == "eurlex-4k" ]; then
	default_models=(xlnet)
	ens_method=softmax_average
elif [ ${data} == "wiki10-31k" ]; then
	default_models=(roberta)
	ens_method=rank_average
elif [ ${data} == "amazoncat-13k" ]; then
	default_models=(bert)
	ens_method=softmax_average
elif [ ${data} == "wiki-500k" ]; then
	default_models=(bert1)
	ens_method=sigmoid_average
elif [ ${data} == "amazon-670k" ]; then
	default_models=(bert1)
	ens_method=softmax_average
elif [ ${data} == "amazon-3m" ]; then
	default_models=(bert1)
	ens_method=rank_average
else
	echo "Unknown dataset: $data"
	exit 1
fi

# 如果传入模型参数，则使用之；否则使用默认
if [ -z "$model_input" ]; then
	models=("${default_models[@]}")
else
	models=($model_input)
fi

Preds=""
Tags=""

# 运行每个模型的训练与预测
for mm in "${models[@]}"; do
	bash train_and_predict.sh ${data} ${mm} ${data_dir}
	Preds="${Preds} models/${data}/${mm}/Pt.npz"
	Tags="${Tags} ${mm}"
done

Y_tst=${data_dir}/Y.tst.npz # test label matrix

# 集成评估
python ensemble_evaluate.py \
	-y ${Y_tst} \
	-p ${Preds} \
	--tags ${Tags} \
	--ens-method ${ens_method} \
	|& tee models/${data}/ensemble.log

