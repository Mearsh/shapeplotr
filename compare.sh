#!/bin/bash

ml purge
ml R/4.4.0-gfbf-2023b

## Conda activate *conda env for pairwise.py*

## Set directories
SHAPE=/path/to/shape/dir
ALIGNPY=${SHAPE}/pairwise.py
OUT_DIR=${SHAPE}/plots/comparisons
mkdir -p ${OUT_DIR}

# References
REF_DIR=/path/to/ref/seqs
REF1=${REF_DIR}/seq1.fa
REF2=${REF_DIR}/seq2.fa
ALIGN_FILE=${REF_DIR}/"alignment.tsv"

## Run pairwise.py

if [[ ! -f $ALIGN_FILE ]]; then
	echo "Creating alignment file..."
    python3 "$ALIGNPY" --ref $REF1 --query $REF2 --out $ALIGN_FILE
fi

## Run shapecomparr

# Parameters
NAME1=seq1
NAME2=seq2

# Replicates
SEQ1_R1=${SHAPE}/rep1/rf-combine/
SEQ1_R2=${SHAPE}/rep2/rf-combine/
SEQ1_R3=${SHAPE}/rep3/rf-combine/

SEQ2_R1=${SHAPE}/rep1/rf-combine/
SEQ2_R2=${SHAPE}/rep2/rf-combine/
SEQ2_R3=${SHAPE}/rep3/rf-combine/

RUN_NAME=SEQ1vSEQ2_DMS
Rscript shapecomparr \
-o $OUT_DIR/$RUN_NAME.pdf \
-x "${SEQ1_R1}/DMS/${NAME1}.wig,${SEQ1_R2}/DMS/${NAME1}.wig,${SEQ1_R3}/DMS/${NAME1}.wig,${SEQ2_R1}/DMS/${NAME2}.wig,${SEQ2_R2}/DMS/${NAME2}.wig,${SEQ2_R3}/DMS/${NAME2}.wig" \
--groups "Seq1 DMS,Seq1 DMS,Seq1 DMS,Seq2 DMS,Seq2 DMS,Seq2 DMS" \
--heatmap \
--heatmap_thresholds "0,0.3,0.7" \
-r '100:500'
