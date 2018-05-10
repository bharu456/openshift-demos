#!/bin/bash
. $(dirname ${BASH_SOURCE})/util.sh
backtotop
desc 'Current Openshift/k8s cluster'
run 'oc get nodes'

backtotop
desc 'Openshift webconsole'
run 'open http://store-store.summit.ck.osecloud.com'


backtotop
desc 'Recommendations API mock'
run 'open https://raw.githubusercontent.com/debianmaster/store-recommendations/master/products.json'

backtotop
desc "Create Open API spec for Reccomendations API"
run 'open https://studio.apicur.io'



