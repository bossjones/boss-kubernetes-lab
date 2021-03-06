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

# Delete everything

```
minikube stop;
minikube delete;
rm -rf ~/.minikube .kube;
brew uninstall kubectl;
brew cask uninstall docker virtualbox minikube;
```


# Minikube Networking

## Networking

The minikube VM is exposed to the host system via a host-only IP address, that can be obtained with the `minikube ip` command.
Any services of type `NodePort` can be accessed over that IP address, on the NodePort.

To determine the NodePort for your service, you can use a `kubectl` command like this (note that `nodePort` begins with lowercase `n` in JSON output):

`kubectl get service $SERVICE --output='jsonpath="{.spec.ports[0].nodePort}"'`

We also have a shortcut for fetching the minikube IP and a service's `NodePort`:

`minikube service --url $SERVICE`

### LoadBalancer emulation (`minikube tunnel`)

Services of type `LoadBalancer` can be exposed via the `minikube tunnel` command.

````shell
minikube tunnel
````

Will output:

```
out/minikube tunnel
Password: *****
Status:
        machine: minikube
        pid: 59088
        route: 10.96.0.0/12 -> 192.168.99.101
        minikube: Running
        services: []
    errors:
                minikube: no errors
                router: no errors
                loadbalancer emulator: no errors


````

Tunnel might ask you for password for creating and deleting network routes.

# Cleaning up orphaned routes

If the `minikube tunnel` shuts down in an unclean way, it might leave a network route around.
This case the ~/.minikube/tunnels.json file will contain an entry for that tunnel.
To cleanup orphaned routes, run:
````
minikube tunnel --cleanup
````

# (Advanced) Running tunnel as root to avoid entering password multiple times

`minikube tunnel` runs as a separate daemon, creates a network route on the host to the service CIDR of the cluster using the cluster's IP address as a gateway.
Adding a route requires root privileges for the user, and thus there are differences in how to run `minikube tunnel` depending on the OS.

Recommended way to use on Linux with KVM2 driver and MacOSX with Hyperkit driver:

`sudo -E minikube tunnel`

Using VirtualBox on Windows, Mac and Linux _both_ `minikube start` and `minikube tunnel` needs to be started from the same Administrator user session otherwise [VBoxManage can't recognize the created VM](https://forums.virtualbox.org/viewtopic.php?f=6&t=81551).
