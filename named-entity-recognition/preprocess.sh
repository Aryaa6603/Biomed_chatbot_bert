#!/bin/bash
ENTITIES="NCBI-disease BC5CDR-disease BC5CDR-chem BC4CHEMD JNLPBA BC2GM linnaeus s800"
MAX_LENGTH=128
SCRIPT_FILE=named-entity-recognition/scripts/preprocess.py
for ENTITY in $ENTITIES
do
	echo "***** " $ENTITY " Preprocessing Start *****"
	DATA_DIR=datasets/NER/$ENTITY
  PREPROCESSED_DIR=preprocessed_datasets/NER/$ENTITY
  mkdir -p $PREPROCESSED_DIR
  

	# Replace tab to space
	cat $DATA_DIR/train.tsv | tr '\t' ' ' > $PREPROCESSED_DIR/train.txt.tmp
	cat $DATA_DIR/devel.tsv | tr '\t' ' ' > $PREPROCESSED_DIR/devel.txt.tmp
	cat $DATA_DIR/train_dev.tsv | tr '\t' ' ' > $PREPROCESSED_DIR/train_dev.txt.tmp
	cat $DATA_DIR/test.tsv | tr '\t' ' ' > $PREPROCESSED_DIR/test.txt.tmp
	echo "Replacing Done"

	# Preprocess for BERT-based models
	python $SCRIPT_FILE $PREPROCESSED_DIR/train.txt.tmp bert-base-cased $MAX_LENGTH > $PREPROCESSED_DIR/train.txt
	python $SCRIPT_FILE $PREPROCESSED_DIR/devel.txt.tmp bert-base-cased $MAX_LENGTH > $PREPROCESSED_DIR/devel.txt
	python $SCRIPT_FILE $PREPROCESSED_DIR/train_dev.txt.tmp bert-base-cased $MAX_LENGTH > $PREPROCESSED_DIR/train_dev.txt
	python $SCRIPT_FILE $PREPROCESSED_DIR/test.txt.tmp bert-base-cased $MAX_LENGTH > $PREPROCESSED_DIR/test.txt
	cat $PREPROCESSED_DIR/train.txt $PREPROCESSED_DIR/devel.txt $PREPROCESSED_DIR/test.txt | cut -d " " -f 2 | grep -v "^$"| sort | uniq > $PREPROCESSED_DIR/labels.txt
	echo "Removing .tmp files"
	rm $PREPROCESSED_DIR/*.tmp

	echo "***** " $ENTITY " Preprocessing Done *****"
done
