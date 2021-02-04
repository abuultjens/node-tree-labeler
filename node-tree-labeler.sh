#!/bin/bash

# $ sh sh.sh INFILE_TREE ASR_MFA SNP_TABLE SITE OUTFILE


INFILE_TREE=${1}
ASR_MFA=${2}
SNP_TABLE=${3}
SITE=${4}

# generate random prefix for all tmp files
RAND_1=`echo $((1 + RANDOM % 100))`
RAND_2=`echo $((100 + RANDOM % 200))`
RAND_3=`echo $((200 + RANDOM % 300))`
DB_RAND=`echo "${RAND_1}${RAND_2}${RAND_3}"`

# make node fofn
grep ">" node_sequences.fasta | cut -f 2 -d '>' > node_fofn.txt

# make attributes file for taxa
COL_NUMBER=`tail -n +2 ${SNP_TABLE} | tr '\t' ',' | grep -n ^"${SITE}," | cut -f 1 -d ':'`
head -1 ${SNP_TABLE} > head.txt
tail -n +2 ${SNP_TABLE} | head -${COL_NUMBER} | tail -1 > seq.txt
cat head.txt seq.txt | tr ',' '\t' | datamash transpose -H | tr '\t' ',' | tail -n +2 > tmp.csv
echo "TAXA,POS" > head.txt
cat head.txt tmp.csv | tr ',' '\t' > VAR_${SITE}_attributes.txt


# make ASR db
echo "COL_NUMBER=${COL_NUMBER}"
grep -v ">" ${ASR_MFA} | cut -b${COL_NUMBER} > ${DB_RAND}_tmp.seq
grep ">" ${ASR_MFA} | tr -d '>' > ${DB_RAND}_tmp_col.txt
paste ${DB_RAND}_tmp_col.txt ${DB_RAND}_tmp.seq | tr '\t' ',' > ${DB_RAND}_DB.csv

START=`head -1 node_fofn.txt`

for TAXA in $(cat node_fofn.txt); do

        # generate random prefix for all tmp files
        RAND_1=`echo $((1 + RANDOM % 100))`
        RAND_2=`echo $((100 + RANDOM % 200))`
        RAND_3=`echo $((200 + RANDOM % 300))`
        RAND=`echo "${RAND_1}${RAND_2}${RAND_3}"`

	BASE=`grep ^"${TAXA}," ${DB_RAND}_DB.csv | cut -f 2 -d ','`

	if [ "${TAXA}" == "${START}" ]; then	
		echo "replaced ${TAXA} with ${BASE}"
		sed "s/${TAXA}\[/${BASE}\[/g" < ${INFILE_TREE} > ${RAND}_TMP.nwk
	else
		echo "replaced ${TAXA} with ${BASE}"
		sed "s/${TAXA}\[/${BASE}\[/g" < ${OLD_RAND}_TMP.nwk > ${RAND}_TMP.nwk
	fi
	
	OLD_RAND=${RAND}
	
done


echo "wrote outfile as ASR_labled_${SITE}_nexus.tre"
mv ${RAND}_TMP.nwk ASR_labled_${SITE}_nexus.tre

rm *_TMP.nwk
rm *${DB_RAND}*
