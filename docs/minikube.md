# minikube

## Addons

### List Addons

```
$ minikube addons list

- addon-manager: enabled
- coredns: enabled
- dashboard: enabled
- default-storageclass: enabled
- efk: disabled
- freshpod: disabled
- heapster: disabled
- ingress: disabled
- kube-dns: disabled
- metrics-server: disabled
- nvidia-driver-installer: disabled
- nvidia-gpu-device-plugin: disabled
- registry: disabled
- registry-creds: disabled
- storage-provisioner: enabled
```


### Enable heapster

```
# Enable heapster
$ minikube addons enable heapster
heapster was successfully enabled

# view the od and service you just created:
$kubectl get po,svc -n kube-system

NAME                                        READY   STATUS    RESTARTS   AGE
pod/coredns-c4cffd6dc-2r5ps                 1/1     Running   0          34m
pod/etcd-minikube                           1/1     Running   0          33m
pod/kube-addon-manager-minikube             1/1     Running   0          34m
pod/kube-apiserver-minikube                 1/1     Running   0          34m
pod/kube-controller-manager-minikube        1/1     Running   0          34m
pod/kube-dns-86f4d74b45-kvs25               3/3     Running   0          34m
pod/kube-proxy-2bq5z                        1/1     Running   0          34m
pod/kube-scheduler-minikube                 1/1     Running   0          33m
pod/kubernetes-dashboard-6f4cfc5d87-pd8xt   1/1     Running   0          34m
pod/storage-provisioner                     1/1     Running   0          34m
pod/tiller-deploy-6fd8d857bc-fqgff          1/1     Running   0          7m

NAME                           TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)         AGE
service/kube-dns               ClusterIP   10.96.0.10      <none>        53/UDP,53/TCP   34m
service/kubernetes-dashboard   ClusterIP   10.96.13.213    <none>        80/TCP          34m
service/tiller-deploy          ClusterIP   10.98.235.220   <none>        44134/TCP       7m
```

