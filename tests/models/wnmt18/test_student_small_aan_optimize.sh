#!/bin/bash

# Exit on error
set -e

model=model.student.small.aan

# Run test
cat newstest2014.in | $MRT_MARIAN/build/marian-decoder \
    -m $MRT_MODELS/wnmt18/$model/model.npz \
    -v $MRT_MODELS/wnmt18/vocab.ende.{yml,yml} \
    --mini-batch-words 384 --mini-batch 100 --maxi-batch 100 --maxi-batch-sort src -b 1 --optimize \
    --shortlist $MRT_MODELS/wnmt18/lex.s2t 100 75 --cpu-threads=1 --skip-cost --max-length-factor 1.2 \
    > optimize_aan.out

cat optimize_aan.out | perl -pe 's/@@ //g' \
    | $MRT_TOOLS/moses-scripts/scripts/recaser/detruecase.perl \
    | $MRT_TOOLS/moses-scripts/scripts/generic/multi-bleu.perl newstest2014.ref \
    | $MRT_TOOLS/extract-bleu.sh > optimize_aan.bleu

$MRT_TOOLS/diff-floats.py optimize_aan.bleu optimize_aan.bleu.expected -p 0.3 > optimize_aan.bleu.diff

# Exit with success code
exit 0
