import os
import csv
import glob

# 路径配置
PRED_ROOT = "/public_bme2/Share200T/caoshui2024/Project2_Deeplearning/CorticalFlow++/results/exp1/pred_surf_res"
GT_ROOT = "/public_bme2/bme-dgshen/caoshui2024/JM-pipeline-original/Step04_sMRI_Signal_Surfaces"
OUTPUT_CSV = "/public_bme2/Share200T/caoshui2024/Project2_Deeplearning/CorticalFlow++/results/exp1/eval_res/eval_list.csv"

# 获取所有 subject_id 目录
subject_dirs = [d for d in os.listdir(PRED_ROOT) if os.path.isdir(os.path.join(PRED_ROOT, d))]

rows = []

for subject_id in sorted(subject_dirs):
    pred_subject_dir = os.path.join(PRED_ROOT, subject_id)
    # 查找所有符合 *_Df2.white 的预测文件
    pred_files = glob.glob(os.path.join(pred_subject_dir, f"{subject_id}_*_Df2.white"))
    
    for pred_file in pred_files:
        basename = os.path.basename(pred_file)
        # 去掉 _Df2.white 后缀
        if basename.endswith("_Df2.white"):
            prefix = basename[:-len("_Df2.white")]
            # 确保以 subject_id 开头
            if prefix.startswith(subject_id + "_"):
                surface_id = prefix[len(subject_id) + 1:]  # 提取 lh_inner 这部分
            else:
                continue  # 跳过不匹配的文件
        else:
            continue

        # 解析 surface_id: e.g., "lh_inner" -> hemisphere="lh", surf_type="inner"
        parts = surface_id.split("_")
        if len(parts) < 2:
            print(f"Warning: invalid surface_id format: {surface_id}")
            continue
        hemisphere = parts[0]
        surf_type = parts[1]

        # 构造 gt_mesh_path
        gt_mesh_path = os.path.join(
            GT_ROOT,
            subject_id,
            "surf",
            f"{hemisphere}_low_signal_{surf_type}.white"
        )

        # pred_mesh_path 就是当前 pred_file
        pred_mesh_path = pred_file

        rows.append({
            "subject_id": subject_id,
            "surface_id": surface_id,
            "gt_mesh_path": gt_mesh_path,
            "pred_mesh_path": pred_mesh_path
        })

# 写入 CSV
with open(OUTPUT_CSV, 'w', newline='') as f:
    fieldnames = ["subject_id", "surface_id", "gt_mesh_path", "pred_mesh_path"]
    writer = csv.DictWriter(f, fieldnames=fieldnames)
    writer.writeheader()
    writer.writerows(rows)

print(f"✅ Successfully generated {OUTPUT_CSV} with {len(rows)} entries.")