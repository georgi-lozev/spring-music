#!/usr/bin/env bash

########################
# include the magic
########################
. ~/workspace/demo-magic/demo-magic.sh


########################
# Configure the options
########################

#
# speed at which to simulate typing. bigger num = faster
#
# TYPE_SPEED=20

#
# custom prompt
#
# see http://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/bash-prompt-escape-sequences.html for escape sequences
#
DEMO_PROMPT="${GREEN}\h ➜ ${CYAN}\w "

# hide the evidence
clear
cd ~/workspace/spring-music || return
export PATH=$PATH:/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/bin
swim lava-bolt > /dev/null 2>&1
cf target -o demo -s demo > /dev/null 2>&1
cf cs azure-postgresql-9-6 basic db -c "{ \"location\": \"eastus\", \"resourceGroup\": \"demo\", \"firewallRules\" : [ { \"name\": \"AllowAll\", \"startIPAddress\": \"0.0.0.0\", \"endIPAddress\" : \"255.255.255.255\" } ] }" > /dev/null 2>&1
svcat provision db --class azure-postgresql-9-6 --plan basic --params-json '{ "location": "eastus", "resourceGroup": "demo", "firewallRules" : [ { "name": "AllowAll", "startIPAddress": "0.0.0.0", "endIPAddress" : "255.255.255.255" } ] }' > /dev/null 2>&1
cf stop spring-music > /dev/null 2>&1
cf unbind-service spring-music db > /dev/null 2>&1
cf ds -f my-db > /dev/null 2>&1
kubectl delete -f k8s/spring-music.yml > /dev/null 2>&1
svcat unbind --name db-binding > /dev/null 2>&1
svcat deprovision my-db > /dev/null 2>&1


pe "cd ~/workspace/spring-music"

# CF demo
pe "cf marketplace"
pe "cf create-service azure-postgresql-9-6 basic my-db -c '{ \"location\": \"eastus\", \"resourceGroup\": \"demo\", \"firewallRules\" : [ { \"name\": \"AllowAll\", \"startIPAddress\": \"0.0.0.0\", \"endIPAddress\" : \"255.255.255.255\" } ] }'"
pe "cf services"
pe "cf apps"
pe "cf env spring-music"
pe "cf bind-service spring-music db"
pe "cf env spring-music"
pe "cf start spring-music"

cmd

# k8s demo
pe "svcat get classes"
pe "svcat provision my-db --class azure-postgresql-9-6 --plan basic --params-json '{ \"location\": \"eastus\", \"resourceGroup\": \"demo\", \"firewallRules\" : [ { \"name\": \"AllowAll\", \"startIPAddress\": \"0.0.0.0\", \"endIPAddress\" : \"255.255.255.255\" } ] }'"
pe "svcat get instances"
pe "svcat bind db --name db-binding"
pe "svcat get bindings"
pe "svcat describe binding db-binding --show-secrets"
pe "vim k8s/spring-music.yml"
pe "kubectl create -f k8s/spring-music.yml"
pe "kubectl get services --field-selector metadata.name=spring-music-service"
pe "watch kubectl get services --field-selector metadata.name=spring-music-service"

cmd

# show a prompt so as not to reveal our true nature after
# the demo has concluded
p ""
