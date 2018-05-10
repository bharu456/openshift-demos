#!/bin/bash
. $(dirname ${BASH_SOURCE})/util.sh
backtotop
desc 'Create JWT auth spec'
run "cat $(relative auth/auth-spec.yaml)"
run "oc apply -f $(relative auth/auth-spec.yaml)"


backtotop
desc 'Create JWT auth spec binding'
run "cat $(relative auth/auth-spec-binding.yaml)"
run "oc apply -f $(relative auth/auth-spec-binding.yaml)"