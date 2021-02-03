#!/bin/bash

# $ sh sh.sh INFILE_TREE NODE_FOFN ASR_MFA SITE OUTFILE

INFILE_TREE=${1}
NODE_FOFN=${2}
ASR_MFA=${3}
SITE=${4}
OUTFILE=${5}

# generate random prefix for all tmp files
RAND_1=`echo $((1 + RANDOM % 100))`
RAND_2=`echo $((100 + RANDOM % 200))`
RAND_3=`echo $((200 + RANDOM % 300))`
DB_RAND=`echo "${RAND_1}${RAND_2}${RAND_3}"`

grep -v ">" ${ASR_MFA} | cut -b${SITE} > ${DB_RAND}_tmp.seq
grep ">" ${ASR_MFA} | tr -d '>' > ${DB_RAND}_tmp_col.txt
paste ${DB_RAND}_tmp_col.txt ${DB_RAND}_tmp.seq | tr '\t' ',' > ${DB_RAND}_DB.csv

START=`head -1 ${NODE_FOFN}`

for TAXA in $(cat ${NODE_FOFN}); do

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

echo "wrote outfile as ${OUTFILE}"
mv ${RAND}_TMP.nwk ${OUTFILE}

rm *_TMP.nwk
rm *${DB_RAND}*
