# KubernetesScripts
Kubernetes helper scripts  
Assuming user has active ibmcloud/kubectl config terminal open from which scripts will be run
#### CheckWorkerNodes.sh
Checks worker nodes for a cluster user has access to
#### CleanReplicasNoPods.sh
Checks namespace for replicas with no active pods and removes them
#### Get0PodsAvailableFromDeployment.sh
Gets list of deployments in namespace with 0 pods
#### RemovePodsInTerminatingState.sh
Checks namespace for pods stuck in terminating state and removes them
