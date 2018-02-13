#!/bin/bash

# Exit on error
set -e

# Test code goes here
mkdir -p word_maxibatch
rm -rf word_maxibatch/* word_maxibatch.log

$MRT_MARIAN/build/marian \
    --seed 6666 --no-shuffle \
    -m word_maxibatch/model.npz -t train.1k.{de,en} -v vocab.{de,en}.yml \
    --log word_maxibatch.log --disp-freq 10 --after-batches 100 --mini-batch 16 \
    --data-weighting train.1k.wordinc.txt --data-weighting-type word

test -e word_maxibatch/model.npz
test -e word_maxibatch.log

$MRT_TOOLS/extract-costs.sh < word_maxibatch.log > word_maxibatch.out
$MRT_TOOLS/diff-floats.py word_maxibatch.out word_maxibatch.expected -p 0.3 > word_maxibatch.diff

# Exit with success code
exit 0