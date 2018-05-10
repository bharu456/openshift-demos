#!/bin/bash

. $(dirname ${BASH_SOURCE})/util.sh


desc 'Provide image-pull access to QA on dev namespace'
run 'oc policy add-role-to-user edit system:serviceaccount:bi-qa:jenkins -n bi-dev'


desc "Deploy reccomendations application in bi namespace"
run 'istioctl kube-inject -f <(oc new-app debianmaster/store-recommendations:v1 --name=recommendations -l app=recommendations,version=v1 --dry-run -o yaml -n bi) | oc apply -n bi -f-'

desc 'Deploy newer version of products api that can talk to recommendations'
run 'istioctl kube-inject -f <(oc new-app debianmaster/store-products:recommendations --name=products-recco -l app=products,version=recommendations --dry-run -o yaml) | oc apply -n store -f-'




