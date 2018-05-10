#!/bin/bash

. $(dirname ${BASH_SOURCE})/util.sh

desc "Dev pipeline"
run 'open https://raw.githubusercontent.com/debianmaster/ms-on-k8s/master/dev-pipeline.yaml'

desc 'Setup dev pipeline'
run 'oc apply -f https://raw.githubusercontent.com/debianmaster/ms-on-k8s/master/dev-pipeline.yaml'

desc 'start pipeline'
run 'oc start-build recco-dev-pipeline'

desc 'Provide image-pull access to QA on dev namespace'
run 'oc policy add-role-to-user edit system:serviceaccount:bi-qa:jenkins -n bi-dev'







