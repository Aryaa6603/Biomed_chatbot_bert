#!/bin/bash
ENTITIES="euadr GAD"
MAX_LENGTH=128
SCRIPT_FILE=relation-extraction/scripts/preprocess.py

for ENTITY in $ENTITIES
do
	echo "***** " $ENTITY " Preprocessing Start *****"
	for SPLIT in {1..10}
	do
		DATA_DIR=datasets/RE/$ENTITY/$SPLIT
		PREPROCESSED_DIR=preprocessed_datasets/RE/$ENTITY/$SPLIT
		mkdir -p $PREPROCESSED_DIR
	
		# Preprocess for BERT-based models
		python $SCRIPT_FILE $DATA_DIR/train.tsv train  > $PREPROCESSED_DIR/train.tsv
		python $SCRIPT_FILE $DATA_DIR/test.tsv test > $PREPROCESSED_DIR/test.tsv
		
	done
	echo "***** " $ENTITY " Preprocessing Done *****"
done
