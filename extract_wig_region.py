#!/usr/bin/env python3

import argparse

def parse_wig(file_path):
    """Parses a variableStep WIG file into a dict: {position: reactivity}"""
    reactivities = {}
    with open(file_path, 'r') as f:
        lines = f.readlines()

    for line in lines:
        if line.startswith("track") or line.startswith("variableStep"):
            continue
        parts = line.strip().split()
        if len(parts) == 2:
            pos = int(parts[0])
            val = float(parts[1])
            reactivities[pos] = val

    return reactivities

def extract_region(reactivities, start, end):
    """Returns a list of reactivities from start to end (1-based, inclusive), filling missing with 0.0"""
    return [reactivities.get(pos, 0.0) for pos in range(start, end + 1)]

def main():
    parser = argparse.ArgumentParser(description="Extract reactivity values for a region from a .wig file.")
    parser.add_argument("file", help="Path to the .wig file")
    parser.add_argument("start", type=int, help="Start position (1-based)")
    parser.add_argument("end", type=int, help="End position (1-based, inclusive)")
    args = parser.parse_args()

    reactivities = parse_wig(args.file)
    region_vals = extract_region(reactivities, args.start, args.end)

    for val in region_vals:
        print(f"{val:.3f}")

if __name__ == "__main__":
    main()
