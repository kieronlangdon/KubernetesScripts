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
    echo "[INFO]  - Usage: ./CleanOldJobs.sh [ENV] [TEMP-FILE0] [TEMP-FILE1] . "
    exit 1
  fi
}

remove_old_files()
{
  echo "[INFO]  - Removing old local files ${FILE}.txt ${CLEANED}.txt"
  rm -rf ${FILE}.txt ${CLEANED}.txt
}

get_all_jobs_old()
{
  echo "[INFO]  - Getting all jobs that are old, adding to ${FILE}.txt"
  kubectl get jobs -n ${ENV} | awk 'match($4,/[0-9]+d/)' > ${FILE}.txt #Get Jobs that are old
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
  echo "[INFO]  - Deleting the job(s) as listed in ${CLEANED}.txt"
  cat ${CLEANED}.txt | while read line
   do
     kubectl delete -n ${ENV} job $line #DEL the job(s) as listed in ${CLEANED}.txt
   done
}

main()
{
 are_vars_defined
 remove_old_files
 get_all_jobs_old
 grab_first_column
 clean_and_delete
}

main
