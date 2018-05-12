
## Run as cluster administrator
`oc cluster up`  #openshift 3.7     
`oc login -u system:admin`

## Install Istio
`oc project myproject`  
`oc adm policy add-scc-to-user anyuid  -z default`  
`oc adm policy add-scc-to-user privileged -z default`  


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





## Deploy bookInfo app
`source istio.VERSION`   #if you want stable versions in master   
`oc apply -f <(istioctl kube-inject --hub $PILOT_HUB --tag $PILOT_TAG -f samples/apps/bookinfo/bookinfo.yaml  -n myproject)`  
`oc expose svc servicegraph`  


## Test service mesh / using grafana pod (it can be another pod)   
`export GRAFANA=$(oc get pods -l app=grafana -o jsonpath={.items[0].metadata.name})`  
`oc exec $GRAFANA -- curl -o /dev/null -s -w "%{http_code}\n" http://istio-ingress/productpage`   
`open http://$(oc get routes servicegraph -o jsonpath={.spec.host})/dotviz` 


## Extra hacks
### Multin-namespace support
> By adding following two objects to any namespace you can make istio support it

```yaml
kind: "Service"
apiVersion: "v1"
metadata:
 name: "istio-pilot"
spec:
 type: ExternalName
 externalName: istio-pilot.myproject.svc.cluster.local
selector: {}
```

```yaml
apiVersion: v1
data:
  mesh: |-
    mixerAddress: istio-mixer.myproject.svc.cluster.local:9091
    discoveryAddress: istio-pilot.myproject.svc.cluster.local:8080
    ingressService: istio-ingress.myproject.svc.cluster.local
    statsdUdpAddress: istio-mixer.myproject.svc.cluster.local:9125
    zipkinAddress: zipkin.myproject.svc.cluster.local:9411
kind: ConfigMap
metadata:
  name: istio
```
