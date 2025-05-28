#!/usr/bin/env python3

import argparse

def extract_region_from_db(file_path, start, end):
    with open(file_path, 'r') as f:
        lines = f.readlines()
        if len(lines) < 3:
            raise ValueError("File must have at least three lines: >header, sequence, and structure.")

        sequence = lines[1].strip()
        structure = lines[2].strip()

        if end > len(sequence):
            raise ValueError(f"End position {end} exceeds sequence length {len(sequence)}.")

        start_idx = start - 1
        end_idx = end

        sub_seq = sequence[start_idx:end_idx]
        sub_struct = structure[start_idx:end_idx]

        return sub_seq, sub_struct

def main():
    parser = argparse.ArgumentParser(description="Extract subsequence and structure from a .db file.")
    parser.add_argument("file", help="Path to the .db file")
    parser.add_argument("start", type=int, help="Start position (1-based)")
    parser.add_argument("end", type=int, help="End position (1-based, inclusive)")
    args = parser.parse_args()

    try:
        seq, struct = extract_region_from_db(args.file, args.start, args.end)
        print(">subsequence")
        print(seq)
        print(struct)
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    main()
