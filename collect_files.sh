#!/usr/bin/env python3
import os
import shutil
import sys
from pathlib import Path

if len(sys.argv) < 3:
    print("Usage: ./collect_files.sh [--max_depth N] input_dir output_dir")
    sys.exit()

max_depth = -1
if sys.argv[1] == "--max_depth":
    max_depth = int(sys.argv[2])
    input_dir = sys.argv[3]
    output_dir = sys.argv[4]
else:
    input_dir = sys.argv[1]
    output_dir = sys.argv[2]

input_path = Path(input_dir)
output_path = Path(output_dir)
output_path.mkdir(exist_ok=True)

for root,dirs,files in os.walk(input_dir):
    depth = Path(root).relative_to(input_path).parts
    curent_depth = len(depth)

    if max_depth != -1 and curent_depth > max_depth:
        continue
    
    for file in files:
        src = Path(root)/file

        if max_depth != -1 and curent_depth == max_depth:
            rel_path = Path(root).relative_to(input_path).parts
            dst_dir = output_path / rel_path
            dst_dir.mkdir(parents = True, exist_ok = True)
            dst = dst_dir / file
        else:
            dst = output_path / file

        counter = 1
        base,ext = os.path.splitext(file)
        while dst.exsists():
            dst = output_path/ f"{base}_{counter}{ext}" if max_depth == -1 else dst_dir/ f"{base}_{counter}{ext}"
            counter += 1

        shutil.copy2(src,dst)