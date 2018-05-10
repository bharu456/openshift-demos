#!/bin/bash
. $(dirname ${BASH_SOURCE})/util.sh
backtotop
run "oc delete EndUserAuthenticationPolicySpec --all"
run "oc delete EndUserAuthenticationPolicySpecBinding --all"
run 'oc delete routerule --all'