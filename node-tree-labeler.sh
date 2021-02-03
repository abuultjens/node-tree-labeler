#!/bin/bash

INFILE_TREE=${1}
NODE_FOFN=${2}
OUTFILE_TREE=${3}

####################################################################

START=`head -1 $1`

for TAXA in $(cat ${NODE_FOFN}); do

        # generate random prefix for all tmp files
        RAND_1=`echo $((1 + RANDOM % 100))`
        RAND_2=`echo $((100 + RANDOM % 200))`
        RAND_3=`echo $((200 + RANDOM % 300))`
        RAND=`echo "${RAND_1}${RAND_2}${RAND_3}"`

	BASE=`grep ^"${TAXA}," ${INFILE_TREE} | cut -f 2 -d ','`

	if [ "${TAXA}" == "${START}" ]; then	
		echo "replaced ${TAXA} with ${BASE}"
		sed "s/${TAXA}\[/${BASE}\[/g" < node_labelled_nexus.tre > ${RAND}_TMP.nwk
	else
		echo "replaced ${TAXA} with ${BASE}"
		sed "s/${TAXA}\[/${BASE}\[/g" < ${OLD_RAND}_TMP.nwk > ${RAND}_TMP.nwk
	fi
	
	OLD_RAND=${RAND}
	
done

echo "wrote outfile as ${OUTFILE_TREE}"
mv ${RAND}_TMP.nwk ${OUTFILE_TREE}

rm *_TMP.nwk
