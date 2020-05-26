#!/bin/bash

get_all_clusters()
{
  ibmcloud ks cluster ls #Get listing of pods user can access
}

get_user_input()
{
  read -p "Enter the cluster you would like to see: " arg1
}

show_health()
{
  ibmcloud ks worker ls --cluster $arg1 --show-pools #Show worker nodes health for cluster arg1
}

main()
{
 get_all_clusters
 get_user_input
 show_health
}

main
