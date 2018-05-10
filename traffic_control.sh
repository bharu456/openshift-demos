#!/bin/bash

. $(dirname ${BASH_SOURCE})/util.sh

backtotop
desc 'Clean all rules'
read -s
run "oc delete routerules --all"

backtotop
desc 'Route all traffic to only version 1'
read -s
run "cat $(relative rules/all-traffic-to-v1.yaml)"
run "oc apply -f $(relative rules/all-traffic-to-v1.yaml)"

backtotop
desc 'Split traffic to v1 and recomendations'
read -s
run "oc delete routerules --all"
run "cat $(relative rules/split-50-50.yaml)"
run "oc apply -f $(relative rules/split-50-50.yaml)"

backtotop
desc 'Reccomendations to json only'
read -s
run "cat $(relative rules/only-to-json.yaml)"
run "oc apply -f $(relative rules/only-to-json.yaml)"

