#!/bin/bash

# Directories
DATA=$PWD
COMBINE=${DATA}/rf-combine
FOLD=${DATA}/rf-fold
OUTPUT=${DATA}/subsets
mkdir -p "$OUTPUT"

# Scripts
BASE=/path/to/shape/folder
STRUCT=${BASE}/extract_db_region.py
WIG=${BASE}/extract_wig_region.py

# Parameters
START=100
END=500

# Process all .wig files in subdirs
find "$COMBINE" -type f -name "*.wig" | while read -r wig_file; do
  # Get subdir name (e.g., DMS) and base filename
  subdir=$(basename "$(dirname "$wig_file")")
  base_name=$(basename "$wig_file" .wig)

  # Create output subdir
  out_subdir="${OUTPUT}/${subdir}"
  mkdir -p "$out_subdir"

  file_name="${base_name}_reactivity_${START}_${END}.txt"

  echo "Processing ${subdir}/${base_name}.wig"
  python3 "$WIG" "$wig_file" $START $END > "${out_subdir}/${file_name}"
done

# Process .db files: rf-fold/<REAGENT>/structures/*.db
find "$FOLD" -type f -path "*/structures/*.db" | while read -r db_file; do
  # Get reagent name from grandparent of file
  reagent=$(basename "$(dirname "$(dirname "$db_file")")")
  base_name=$(basename "$db_file" .db)

  # Create output subdir
  out_subdir="${OUTPUT}/${reagent}"
  mkdir -p "$out_subdir"

  file_name="${base_name}_structure_${START}_${END}.db"

  echo "Processing ${reagent}/structures/${base_name}.db"
  python3 "$STRUCT" "$db_file" $START $END > "${out_subdir}/${file_name}"
done

