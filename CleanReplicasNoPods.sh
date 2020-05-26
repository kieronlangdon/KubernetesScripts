#!/bin/bash
set -e
readonly ENV=${1}
readonly FILE=${2}
readonly CLEANED=${3}

are_vars_defined()
{
  if [[ -z $ENV || -z $FILE || -z $CLEANED  ]];
  then
    echo "[ERROR] - Missing mandatory arguments: ENV, TEMP-FILE0 and TEMP-FILE1"
    echo "[INFO]  - Usage: ./CleanReplicasNoPods.sh [ENV] [TEMP-FILE0] [TEMP-FILE1] . "
    exit 1
  fi
}

remove_old_files()
{
  echo "[INFO]  - Removing old local files ${FILE}.txt ${CLEANED}.txt"
  rm -rf ${FILE}.txt ${CLEANED}.txt
}

get_all_replicas_0()
{
  echo "[INFO]  - Getting all ReplicaSets that have no pods, adding to ${FILE}.txt"
  kubectl get rs -n ${ENV} | awk '$2 ==0 && $3 ==0 && $4 ==0' > ${FILE}.txt #Get ReplicaSets that have no pods
  if [[ -z $(grep '[^[:space:]]' ${FILE}.txt) ]] ; then
  echo "Nothing to clean...Exiting..."
  exit 0
  fi
}

grab_first_column()
{
  echo "[INFO]  - Cleaning up list, adding to ${CLEANED}.txt"
  awk '{print $1}' ${FILE}.txt > ${CLEANED}.txt #Grab the first column of output
}

clean_and_delete()
{
  echo "[INFO]  - Deleting the replicaset(s) as listed in ${CLEANED}.txt"
  cat ${CLEANED}.txt | while read line
   do
     kubectl delete -n ${ENV} replicaset $line #DEL the replicaset(s) as listed in ${CLEANED}.txt
   done
}

main()
{
 are_vars_defined
 remove_old_files
 get_all_replicas_0
 grab_first_column
 clean_and_delete
}

main
