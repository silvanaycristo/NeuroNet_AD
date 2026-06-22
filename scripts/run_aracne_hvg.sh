#!/bin/bash
set -e

JAR="ARACNe-AP/dist/aracne.jar"
GENES="data/hvg_union.txt"
PVAL="1"
RAM="200G"
THREADS=60

EXPR="$1"
LABEL=$(basename $EXPR _hvg.tsv)
OUT="aracne_vip/$LABEL"

mkdir -p $OUT

echo "[$(date)] Threshold - $LABEL"
java -Xmx${RAM} -jar $JAR \
  -e $EXPR \
  -o $OUT \
  --tfs $GENES \
  --pvalue $PVAL \
  --seed 11 \
  --calculateThreshold

THRESH_FILE=$(ls $OUT/miThreshold_*.txt)
echo "0.0" > $THRESH_FILE

echo "[$(date)] ARACNe - $LABEL"
java -Xmx${RAM} -jar $JAR \
  -e $EXPR \
  -o $OUT \
  --tfs $GENES \
  --pvalue $PVAL \
  --nodpi \
  --nobootstrap \
  --seed 11 \
  --threads $THREADS

echo "[$(date)] $LABEL listo. Edges: $(tail -n +2 $OUT/network.txt | wc -l)"
