#!/bin/bash
#SBATCH -J _predict # 作业名
#SBATCH -o _predict_%j.o   # 标准输出文件名，包括作业ID
#SBATCH -e _predict_%j.e   # 标准错误文件名，包括作业ID
#SBATCH -n 1                       # 指定core数量（例如8个）
#SBATCH -p bme_a10080g #bme_gpu                 # 指定分区
#SBATCH -N 1                       # 指定node数量（保持为1，如果任务可以在单个节点上完成）
#SBATCH --time=1:00:00             # 最大wallclock时间
#SBATCH --gres=gpu:1    

# #xiaoqing
# # 激活Conda环境
# source ~/.bashrc
# conda activate Surf
# module load  cuda/7/11.8 
# export LD_LIBRARY_PATH="$HOME/.conda/envs/Surf/lib/python3.9/site-packages/torch/lib:$LD_LIBRARY_PATH"
# which python
# export LD_LIBRARY_PATH=$CONDA_PREFIX/lib:$LD_LIBRARY_PATH


#caoshui
# 激活Conda环境
module load tools/conda/anaconda.2023.09
source activate mri

# 设置工作目录
WORKDIR=/public_bme2/Share200T/caoshui2024/Project2_Deeplearning/CotexODE/code/CortexODE-ce/sbatch_run
cd $WORKDIR || exit


# code_path="/public_bme2/Share200T/caoshui2024/Project2_Deeplearning/CotexODE/code/CortexODE-ce"
# data_path="/public_bme2/bme-dgshen/caoshui2024/JM-pipeline-original/Step04_sMRI_Signal_Surfaces"
# model_save_path="/public_bme2/Share200T/caoshui2024/Project2_Deeplearning/CotexODE/exp/exp_rh_inner_01"
# datasplit_csv_path="/public_bme2/Share200T/caoshui2024/Project2_Deeplearning/CotexODE/code/CortexODE-ce/data/subject_split_original.csv"
# result_dir="/public_bme2/Share200T/caoshui2024/Project2_Deeplearning/CotexODE/exp/exp_rh_inner_01/res"



OUT_DIR="/public_bme2/bme-dgshen/caoshui2024/DP_Project/CorticalFlow++/code/CorticalFlow++/results/exp1"
CONFIG="/public_bme2/bme-dgshen/caoshui2024/DP_Project/CorticalFlow++/code/CorticalFlow++/corticalflow/resources/config_samples/CFPP_predict_lh_5T_inner.yaml"
code="/public_bme2/bme-dgshen/caoshui2024/DP_Project/CorticalFlow++/code/CorticalFlow++/corticalflow/"



python $code/predict_hypo.py user_config="$CONFIG" #in_file=<IN_FILE>   out_dir="$OUT_DIR"