
```sh
oc new-project bi
oc new-project store
oc new-project infra
```

```sh
oc project infra
kubectl apply -f <(istioctl kube-inject -f <(kubectl apply -f http://central.maven.org/maven2/io/fabric8/devops/apps/keycloak/2.2.327/keycloak-2.2.327-kubernetes.yml --dry-run -o yaml)) -n infra
```
```sh
oc adm policy add-scc-to-user privileged -z default -n infra
```

```sh
kubectl expose deploy keycloak --port=8080 --target-port=8080 -n infra
oc expose svc keycloak -n infra 
```


```sh
oc adm policy add-scc-to-user privileged -z default -n store
oc adm policy add-scc-to-user privileged -z default -n bi
oc adm policy add-scc-to-user privileged -z default -n infra

```


export token=$(curl -s -X POST 'http://keycloak:8080/auth/realms/istio/protocol/openid-connect/token' -H "Content-Type: application/x-www-form-urlencoded" -d 'username=demo&password=test&grant_type=password&client_id=cars-web' | jq -r .access_token)


curl -vvv -H "Authorization: Bearer ${token}" http://cars-api:8000


curl -X GET --header 'Accept: application/json' 'http://swagger-spring-myproject.192.168.64.15.nip.io/inventory'

-> Security
-> Monitoring 
-> Traffic control




oc policy add-role-to-user edit system:serviceaccount:cicd:jenkins -n dev
oc policy add-role-to-user edit system:serviceaccount:cicd:jenkins -n qa



mvn io.fabric8:fabric8-maven-plugin:LATEST:setup
tail -n 30 pom.xml
mvn clean install
mvn fabric8:deploy
mvn fabric8:run
mvn fabric8:debug







apiVersion: config.istio.io/v1alpha2
kind: RouteRule
metadata:
  name: products-default
  namespace: store
spec:
  destination:
    name: products
  precedence: 1
  route:
  - labels:
      version: v1
    weight: 50
  - labels:
      version: recommendations
    weight: 50 






apiVersion: config.istio.io/v1alpha2
kind: RouteRule
metadata:
  name: test-recommendations-for-user-jason
spec:
  match:
    request:
      headers:
        cookie:
          regex: ^(.*?;)?(user=jason)(;.*)?$
  destination:
    name: products
    namespace: store
  precedence: 2
  route:
  - labels:
      version: recommendations









--- 
apiVersion: config.istio.io/v1alpha2
kind: EndUserAuthenticationPolicySpec
metadata: 
  name: coolstore-api-auth-policy
  namespace: store
spec: 
  jwts: 
    - issuer: http://keycloak.infra:8080/auth/realms/coolstore
      jwks_uri: http://keycloak.infra:8080/auth/realms/coolstore/protocol/openid-connect/certs
      audiences: 
      - store 



--- 
apiVersion: config.istio.io/v1alpha2
kind: EndUserAuthenticationPolicySpecBinding
metadata:
  name: coolstore-api-auth-policy-binding
  namespace: store
spec:
  policies:
    - name: coolstore-api-auth-policy
      namespace: store
  services:
    - name: products
      namespace: store





curl -s -X POST 'http://keycloak.infra:8080/auth/realms/coolstore/protocol/openid-connect/token' -H "Content-Type: application/x-www-form-urlencoded" -d 'username=demo&password=demo&grant_type=password&client_id=store'


curl -vvv -H "Authorization: Bearer ${token}" http://products:8080/store


101 Andrew Young International Boulevard Northwest

8302 Dunwoody Place, Suite 100, Atlanta, GA, us






swagger-codegen generate -i ~/Downloads/reccomendations.yml -l spring -o ~/reccomendations-api --artifact-id recommendations -c ~/swagger-config.json






env.BRANCH_NAME
env.PROJECT_NAME

isPR        = env.BRANCH_NAME ? env.BRANCH_NAME.startsWith("PR") : false

node('maven'){
	stage ('Build') {
		checkout scm
		sh "mvn clean package"
	}
	stage ('Test') {
		sh "mvn fabric8:deploy"
	}
	stage ('Promote') {
		sh "oc tag store-orders:latest store-orders:promoteToQA"
	}	
}


SPRING_CONFIG_LOCATION
file://:/tmp/application.properties


oc new-build https://github.com/debianmaster/store-orders --context-dir=qa --name=orders-pipeline






kubectl apply -f <(istioctl kube-inject -f <(kubectl run --image=debianmaster/go-welcome cars-api -l app=cars-api,version=v1  -o yaml --dry-run))






kubectl apply -f <(istioctl kube-inject -f <(kubectl run --image=debianmaster/store-fe store -l app=store,version=v1  -o yaml --dry-run))









```sh
oc project store
istioctl kube-inject -f <(oc new-app debianmaster/store-fe --name=store -l app=store,version=v1 --dry-run -o yaml) | oc apply -f-


istioctl kube-inject -f <(oc new-app debianmaster/store-products:v1 --name=products -l app=products,version=v1 --dry-run -o yaml) | oc apply -f-


istioctl kube-inject -f <(oc new-app debianmaster/store-products:recommendations --name=products-recco -l app=products,version=recommendations --dry-run -o yaml) | oc apply -f-


istioctl kube-inject -f <(oc new-app debianmaster/store-recommendations:v1 --name=recommendations -l app=recommendations,version=v1 --dry-run -o yaml -n bi) | oc apply -n bi -f-


oc new-app mongodb -l app=mongodb --name=productsdb \
  -e MONGODB_ADMIN_PASSWORD=password  -e MONGODB_USER=app_user \
  -e MONGODB_DATABASE=store  -e MONGODB_PASSWORD=password

oc env dc products MONGO_USER=app_user MONGO_PASSWORD=password MONGO_SERVER=productsdb MONGO_PORT=27017 MONGO_DB=store \
mongo_url='mongodb://app_user:password@productsdb/store'


oc env dc products-recco MONGO_USER=app_user MONGO_PASSWORD=password MONGO_SERVER=productsdb MONGO_PORT=27017 MONGO_DB=store \
mongo_url='mongodb://app_user:password@productsdb/store'

oc expose svc store
```


```sh
cjonagam-OSX:~ cjonagam$ oc rsh productsdb-1-5fw94
sh-4.2$ mongo
MongoDB shell version v3.4.9
connecting to: mongodb://127.0.0.1:27017
MongoDB server version: 3.4.9
Welcome to the MongoDB shell.
For interactive help, type "help".
For more comprehensive documentation, see
	http://docs.mongodb.org/
Questions? Try the support group
	http://groups.google.com/group/mongodb-user
> use store
switched to db store
> db.auth('app_user','password')
```
```
var categories = [
		{id:1,CatName:"Wireless",SubCats:[{id:1,name:"RF"},{id:2,name:"XBEE"},{id:3,name:"Wifi"},{id:4,name:"Bluetooth"}]},
		{id:2,CatName:"Development Boards",SubCats:[{id:5,name:"Arduino"},{id:6,name:"ARM"},{id:7,name:"8051"},{id:8,name:"AVR"}]},
		{id:3,CatName:"Sensors",SubCats:[{id:9,name:"Ultrasonic"},{id:10,name:"GPS"},{id:11,name:"IR"},{id:12,name:"Light"}]}
	];	

var products=[ {product_id:'cable_1',name:"Wire",title:"Wire",img:'img/storeImages/08566-01-L_l_th.jpg',images:['storeImages/08566-01-L_l_th.jpg'],
        documents:"Wire",features:"Wire",shipping:55,caption:"Cable Wire",price:20,subCat:1}]

db.Categories.insert(categories)

db.Products.insert(products)
```
> Remove this selector from products.

```sh
    deploymentconfig: products
    version: v1
```    
    

oc delete svc products 
oc create service clusterip products --tcp=8080:8080


9885950555



397,548 -- 
399,206.15 --





