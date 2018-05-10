#!/bin/bash

. $(dirname ${BASH_SOURCE})/util.sh

backtotop
desc "Deploy to openshift"
run 'oc new-project bi-dev'
run 'oc project bi-dev'

backtotop
desc "Containerize Code"
run 'cd ~/reccomendations-api'
run 'mvn io.fabric8:fabric8-maven-plugin:LATEST:setup'
run 'tail -n 30 pom.xml'
run 'mvn fabric8:deploy'

backtotop
desc 'ext install vscode-java-debug'
desc 'Debug application'
run 'code .'
run 'mvn fabric8:debug'






