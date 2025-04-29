#!/usr/bin/env python3
import os
import shutil
import sys
from pathlib import Path

args = sys.argv[1:]
max_depth = None
input_dir = None
output_dir = None

if len(args) == 2:
    input_dir, output_dir = args
elif len(args) == 4 and args[0] == "--max_depth":
    max_depth = int(args[1])
    input_dir, output_dir = args[2], args[3]
else:
    print("Usage: ./collect_files.sh input_dir output_dir")
    print("Or: ./collect_files.sh --max_depth N input_dir output_dir")
    sys.exit(1)

input_path = Path(input_dir)
output_path = Path(output_dir)
output_path.mkdir(parents=True, exist_ok=True)

name_counter = {}

for root, _, files in os.walk(input_dir):
    current_depth = len(Path(root).relative_to(input_path).parts)

    if max_depth is not None and current_depth > max_depth:
        continue

    for filename in files:
        src = Path(root) / filename

        if max_depth is not None and current_depth == max_depth:
            rel_path = Path(root).relative_to(input_path)
            dst_dir = output_path / rel_path
            dst_dir.mkdir(parents=True, exist_ok=True)
            dst = dst_dir/ filename
        else:
            dst = output_path / filename

        if dst.exists():
            base, ext = os.path.splitext(filename)
            counter = name_counter.get(base, 1)
            while dst.exists():
                new_name = f"{base}_{counter}{ext}"
                dst = dst.parent / new_name
                counter += 1
            name_counter[base] = counter

        shutil.copy2(src, dst)