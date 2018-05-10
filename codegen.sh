#!/bin/bash

. $(dirname ${BASH_SOURCE})/util.sh
backtotop
desc 'Delete old stuff'
run 'rm -rf ~/reccomendations-api'


backtotop
desc 'Generate Spring code using swagger code-gen'
run 'swagger-codegen generate -i ~/Downloads/reccomendations.yml -l spring -o ~/reccomendations-api --artifact-id recommendations -c ~/swagger-config.json
'

backtotop
desc "Test generated code"
run 'cd ~/reccomendations-api'
run 'mvn clean package'
run 'mvn spring-boot:run'







