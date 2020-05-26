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
    echo "[INFO]  - Usage: ./Get0PodsAvailableFromDeployment.sh [ENV] [TEMP-FILE0] [TEMP-FILE1] . "
    exit 1
  fi
}

remove_old_files()
{
  echo "[INFO]  - Removing old local files ${FILE}.txt ${CLEANED}.txt"
  rm -rf ${FILE}.txt ${CLEANED}.txt
}

get_all_deployments_running_pods()
{
  echo "[INFO]  - Getting all deployments with running pods, adding to ${FILE}.txt"
  kubectl get deployments -o wide -n ${ENV} | awk '$4==1' > ${FILE}.txt #Get deployments with running pods
}

get_all_deployments_nonrunning_pods()
{
  echo "[INFO]  - Getting all deployments with non-running pods, adding to ${CLEANED}.txt"
  kubectl get deployments -o wide -n ${ENV} | awk '$4==0' > ${CLEANED}.txt #Get deployments with non-running pods
}

main()
{
 are_vars_defined
 remove_old_files
 get_all_deployments_running_pods
 get_all_deployments_nonrunning_pods
}

main
