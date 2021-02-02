#!/bin/bash

INFILE=${1}
OUTFILE=${2}


START=`head -1 $1`

for TAXA in $(cat $1); do

        # generate random prefix for all tmp files
        RAND_1=`echo $((1 + RANDOM % 100))`
        RAND_2=`echo $((100 + RANDOM % 200))`
        RAND_3=`echo $((200 + RANDOM % 300))`
        RAND=`echo "${RAND_1}${RAND_2}${RAND_3}"`

	BASE=`grep ^"${TAXA}," test_node_attributes.tr.csv | cut -f 2 -d ','`

	if [ "${TAXA}" == "${START}" ]; then	
		echo "replaced ${TAXA} with ${BASE}"
		sed "s/${TAXA}\[/${BASE}\[/g" < node_labelled_nexus.tre > ${RAND}_TMP.nwk
#		awk '{gsub("${TAXA}[", "${BASE}[", $0); print}' < node_labelled_nexus.tre > ${RAND}_TMP.nwk

	else
		echo "replaced ${TAXA} with ${BASE}"
		sed "s/${TAXA}\[/${BASE}\[/g" < ${OLD_RAND}_TMP.nwk > ${RAND}_TMP.nwk
#		awk '{gsub("${TAXA}[", "${BASE}[", $0); print}' < ${OLD_RAND}_TMP.nwk > ${RAND}_TMP.nwk
	fi
	
	OLD_RAND=${RAND}
	
done

echo "wrote outfile as ${OUTFILE}"
mv ${RAND}_TMP.nwk ${OUTFILE}

rm *_TMP.nwk
