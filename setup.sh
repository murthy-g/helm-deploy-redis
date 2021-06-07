echo "Starting"
NAMESPACE=bi-customer-accessauthz
# https://raw.githubusercontent.com/bitnami/charts/master/bitnami/redis/values.yaml
# grep -o '^[^#]*' values-production.yaml | grep "\S" > values-prod.yaml
# echo "deleting pods from $NAMESPACE"
# kubectl delete pods --all --namespace $NAMESPACE
echo "deleting services from $NAMESPACE"
kubectl delete services --all --namespace $NAMESPACE
echo "deleting statefulset from $NAMESPACE"
kubectl delete statefulset --all --namespace $NAMESPACE
echo "deleting pod redis-client from $NAMESPACE"
kubectl delete pod redis-client --namespace $NAMESPACE
echo "uninstall redis from $NAMESPACE"
helm uninstall redis --namespace $NAMESPACE
helm repo update
echo "install redis into $NAMESPACE"
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm upgrade --install -f values-prod.yaml redis bitnami/redis -n $NAMESPACE
# helm install redis -n $NAMESPACE bitnami/redis --values values-production.yaml

# echo "setting password"
# export REDIS_PASSWORD=$(kubectl get secret --namespace $NAMESPACE redis -o jsonpath="{.data.redis-password}" | base64 --decode)
echo $REDIS_PASSWORD
kubectl get all --namespace $NAMESPACE

echo "attach to pod"
 kubectl run --namespace bi-customer-accessauthz redis-client --restart='Never'  --env REDIS_PASSWORD=$REDIS_PASSWORD  --image docker.io/bitnami/redis:6.2.4-debian-10-r0 --command -- sleep infinity

 
# kubectl run redis-client --rm --tty -i --restart='Never' --image docker.io/bitnami/redis:6.0.1-debian-10-r1 -- bash



# kubectl exec --tty -i redis-client --namespace $NAMESPACE -- bash

# redis-cli -h redis-master -a $REDIS_PASSWORD ping
# redis-cli -h redis-replicas -a $REDIS_PASSWORD ping

#  redis-master.bi-customer-accessauthz.svc.cluster.local for read/write operations (port 6379)
#     redis-replicas.bi-customer-accessauthz.svc.cluster.local for read-only operations (port 6379)

#  redis-master.bi-customer-accessauthz.svc.cluster.local for read/write operations (port 6379)
#     redis-replicas.bi-customer-accessauthz.svc.cluster.local for read-only operations (port 6379)