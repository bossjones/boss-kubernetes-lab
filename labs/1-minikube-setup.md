kubectl cluster-info

kubectl get nodes

kubectl describe node


kubectl create serviceaccount -n kube-system tiller
kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller

`helm init --service-account tiller`
