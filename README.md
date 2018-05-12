
## Run as cluster administrator
`oc cluster up`  #openshift 3.7     
`oc login -u system:admin`

## Install Istio
`oc project myproject`  
`oc adm policy add-scc-to-user anyuid  -z default`  
`oc adm policy add-scc-to-user privileged -z default`  
```sh
oc adm policy add-scc-to-user anyuid -z istio-ingress-service-account -n istio-system
oc adm policy add-scc-to-user anyuid -z istio-egress-service-account -n istio-system
oc adm policy add-scc-to-user anyuid -z istio-pilot-service-account -n istio-system
oc adm policy add-scc-to-user anyuid -z default -n istio-system
oc adm policy add-scc-to-user anyuid -z prometheus -n istio-system
oc adm policy add-scc-to-user anyuid -z grafana -n istio-system
```

## Install Istio Service Mesh
`export ISTIO_HOME=~/Downloads/istio-0.7.1`
`oc create -f ${ISTIO_HOME}/install/kubernetes/istio.yaml`   


## Install addons 
```sh
oc create -f ${ISTIO_HOME}/install/kubernetes/addons/prometheus.yaml
oc create -f ${ISTIO_HOME}/install/kubernetes/addons/grafana.yaml
oc create -f ${ISTIO_HOME}/install/kubernetes/addons/servicegraph.yaml
oc expose svc grafana -n istio-system
oc expose svc servicegraph -n istio-system
oc expose svc prometheus -n istio-system
oc apply -f https://raw.githubusercontent.com/minishift/minishift-addons/master/add-ons/istio/templates/jaeger-all-in-one.yml -n istio-system
```


## Deploy sample app
### Install istioctl first and add to path  
`~/Downloads/istio-0.7.1`  

### For instance on linux
```
curl -LO https://github.com/istio/istio/releases/download/0.2.1/istio-0.2.1-linux.tar.gz
tar zxvf istio-0.2.1-linux.tar.gz
sudo mv istio-0.2.1/bin/istioctl /usr/bin
sudo chmod u+x /usr/bin/istioctl
```



## Test service mesh / using grafana pod (it can be another pod)   
`export GRAFANA=$(oc get pods -l app=grafana -o jsonpath={.items[0].metadata.name})`  
`oc exec $GRAFANA -- curl -o /dev/null -s -w "%{http_code}\n" http://istio-ingress/productpage`   
`open http://$(oc get routes servicegraph -o jsonpath={.spec.host})/dotviz` 

