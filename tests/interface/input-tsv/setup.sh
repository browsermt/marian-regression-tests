# Skip if compiled without SentencePiece
if [ ! $MRT_MARIAN_USE_SENTENCEPIECE ]; then
    exit 100
fi

test -f $MRT_DATA/europarl.de-en/corpus.small.en.gz || exit 1
test -f $MRT_DATA/europarl.de-en/corpus.small.de.gz || exit 1

test -f $MRT_MODELS/ape/model.npz || exit 1
test -f $MRT_MODELS/rnn-spm/model.npz || exit 1
test -f $MRT_MODELS/lmgec/lm.npz || exit 1

# Create training data
test -s train.de  || cat $MRT_DATA/train.max50.de | sed 's/@@ //g' > train.de
test -s train.en  || cat $MRT_DATA/train.max50.en | sed 's/@@ //g' > train.en
test -s train.tsv || paste train.{de,en} > train.tsv

test -s train.bpe.de  || cat $MRT_DATA/train.max50.de > train.bpe.de
test -s train.bpe.en  || cat $MRT_DATA/train.max50.en > train.bpe.en
test -s train.bpe.tsv || paste train.bpe.{de,en} > train.bpe.tsv
