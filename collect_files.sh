#!/usr/bin/env python3
import os
import shutil
import sys
from pathlib import Path

args = sys.argv[1:]

if len(args) < 2:
    print("Usage: ./collect_files.sh input_dir output_dir")
    print("Or: ./collect_files.sh --max_depth N input_dir output_dir")
    sys.exit()

max_depth = None
if args[0] == "--max_depth":
    try:
        max_depth = int(args[1])
        input_dir = args[2]
        output_dir = args[3]
    exept (IndexError, ValueError)
        print("invalid arguments")
        sys.exit(1)
else:
    input_dir = args[0]
    output_dir = args[1]

input_path = Path(input_dir)
output_path = Path(output_dir)
output_path.mkdir(parents = True, exist_ok = True)

f_counter = {}

for root,_,files in os.walk(input_dir):
    depth = Path(root).relative_to(input_path).parts
    curent_depth = len(depth)

    if max_depth is not None and curent_depth > max_depth:
        continue
    
    for file in files:
        src = Path(root)/file

        if max_depth is not None and curent_depth == max_depth:
            rel_path = Path(root).relative_to(input_path)
            dst_dir = output_path / rel_path
            dst_dir.mkdir(parents = True, exist_ok = True)
            dst = dst_dir / file
        else:
            dst = output_path / file

        if dst.exsists():
            counter = f_counter(base,1)
            base,ext = os.path.splitext(file)
            while dst.exsists():
                new_name = f"{base}_{counter}{ext}"
                dst = dst.parent / new_name
                counter += 1
        f_counter[base] = counter

        shutil.copy2(src,dst)