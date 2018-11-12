# cert-manager

```
 malcolm  ⎇  master U:1 ?:1  ⓔ 2.4.3  ~/dev/bossjones/boss-kubernetes-lab/charts/helm/whoami/cert-manager-setup   helm install --name my-release -f cert-manager-values.yaml cert-manager
 malcolm  ⎇  master U:1 ?:1  ⓔ 2.4.3  ~/dev/bossjones/boss-kubernetes-lab/charts/helm/whoami/cert-manager-setup   helm install --name my-release -f cert-manager-values.yaml stable/cert-manager --version v0.3.0
NAME:   my-release
LAST DEPLOYED: Sun Nov 11 20:53:34 2018
NAMESPACE: default
STATUS: DEPLOYED

RESOURCES:
==> v1beta1/Deployment
NAME                     AGE
cert-manager-my-release  0s

==> v1/Pod(related)

NAME                                     READY  STATUS             RESTARTS  AGE
cert-manager-my-release-55c96766b-nc8qc  0/1    ContainerCreating  0         0s

==> v1/ServiceAccount

NAME                     AGE
cert-manager-my-release  0s

==> v1beta1/CustomResourceDefinition
certificates.certmanager.k8s.io    0s
clusterissuers.certmanager.k8s.io  0s
issuers.certmanager.k8s.io         0s

==> v1beta1/ClusterRole
cert-manager-my-release  0s

==> v1beta1/ClusterRoleBinding
cert-manager-my-release  0s


NOTES:
cert-manager has been deployed successfully!

In order to begin issuing certificates, you will need to set up a ClusterIssuer
or Issuer resource (for example, by creating a 'letsencrypt-staging' issuer).

More information on the different types of issuers and how to configure them
can be found in our documentation:

http://cert-manager.readthedocs.io/en/latest/reference/issuers.html

For information on how to configure cert-manager to automatically provision
Certificates for Ingress resources, take a look at the `ingress-shim`
documentation:

http://cert-manager.readthedocs.io/en/latest/reference/ingress-shim.html
```

# nginx-ingress

```

 malcolm  ⎇  master U:1 ?:2  ⓔ 2.4.3  ~/dev/bossjones/boss-kubernetes-lab/charts/helm/whoami/cert-manager-setup   helm install stable/nginx-ingress --namespace kube-system --set controller.hostNetwork=true,controller.kind=DaemonSet
NAME:   rolling-bear
LAST DEPLOYED: Sun Nov 11 21:25:32 2018
NAMESPACE: kube-system
STATUS: DEPLOYED

RESOURCES:
==> v1/ConfigMap
NAME                                   AGE
rolling-bear-nginx-ingress-controller  1s

==> v1/ServiceAccount
rolling-bear-nginx-ingress  1s

==> v1beta1/ClusterRole
rolling-bear-nginx-ingress  1s

==> v1beta1/Role
rolling-bear-nginx-ingress  1s

==> v1beta1/RoleBinding
rolling-bear-nginx-ingress  1s

==> v1beta1/Deployment
rolling-bear-nginx-ingress-default-backend  1s

==> v1beta1/ClusterRoleBinding
rolling-bear-nginx-ingress  1s

==> v1/Service
rolling-bear-nginx-ingress-controller       1s
rolling-bear-nginx-ingress-default-backend  1s

==> v1beta1/DaemonSet
rolling-bear-nginx-ingress-controller  1s

==> v1/Pod(related)

NAME                                                        READY  STATUS             RESTARTS  AGE
rolling-bear-nginx-ingress-controller-lj2w9                 0/1    ContainerCreating  0         1s
rolling-bear-nginx-ingress-default-backend-b5ffb7d7d-wmx7c  0/1    ContainerCreating  0         1s


NOTES:
The nginx-ingress controller has been installed.
It may take a few minutes for the LoadBalancer IP to be available.
You can watch the status by running 'kubectl --namespace kube-system get services -o wide -w rolling-bear-nginx-ingress-controller'

An example Ingress that makes use of the controller:

  apiVersion: extensions/v1beta1
  kind: Ingress
  metadata:
    annotations:
      kubernetes.io/ingress.class: nginx
    name: example
    namespace: foo
  spec:
    rules:
      - host: www.example.com
        http:
          paths:
            - backend:
                serviceName: exampleService
                servicePort: 80
              path: /
    # This section is only required if TLS is to be enabled for the Ingress
    tls:
        - hosts:
            - www.example.com
          secretName: example-tls

If TLS is enabled for the Ingress, a Secret containing the certificate and key must also be provided:

  apiVersion: v1
  kind: Secret
  metadata:
    name: example-tls
    namespace: foo
  data:
    tls.crt: <base64 encoded cert>
    tls.key: <base64 encoded key>
  type: kubernetes.io/tls
```



# kubectl describe pods -n kube-system nginx-ingress-controller-8566746984-drcs6

```
Name:           nginx-ingress-controller-8566746984-drcs6
Namespace:      kube-system
Node:           minikube/172.16.2.230
Start Time:     Sun, 11 Nov 2018 22:19:26 -0500
Labels:         addonmanager.kubernetes.io/mode=Reconcile
                app.kubernetes.io/name=nginx-ingress-controller
                app.kubernetes.io/part-of=kube-system
                pod-template-hash=4122302540
Annotations:    prometheus.io/port: 10254
                prometheus.io/scrape: true
Status:         Running
IP:             172.17.0.8
Controlled By:  ReplicaSet/nginx-ingress-controller-8566746984
Containers:
  nginx-ingress-controller:
    Container ID:  docker://fbd4ebfd68857f728b8077c79b74738166e814650970b2bcc6b510d262a0690a
    Image:         quay.io/kubernetes-ingress-controller/nginx-ingress-controller:0.19.0
    Image ID:      docker-pullable://quay.io/kubernetes-ingress-controller/nginx-ingress-controller@sha256:d4d0f5416c26444fb318c1bf7e149b70c7d0e5089e129827b7dccfad458701ca
    Ports:         80/TCP, 443/TCP, 18080/TCP
    Host Ports:    80/TCP, 443/TCP, 18080/TCP
    Args:
      /nginx-ingress-controller
      --default-backend-service=$(POD_NAMESPACE)/default-http-backend
      --configmap=$(POD_NAMESPACE)/nginx-load-balancer-conf
      --tcp-services-configmap=$(POD_NAMESPACE)/tcp-services
      --udp-services-configmap=$(POD_NAMESPACE)/udp-services
      --annotations-prefix=nginx.ingress.kubernetes.io
      --report-node-internal-ip-address
    State:          Running
      Started:      Sun, 11 Nov 2018 22:19:56 -0500
    Ready:          True
    Restart Count:  0
    Liveness:       http-get http://:10254/healthz delay=10s timeout=1s period=10s #success=1 #failure=3
    Readiness:      http-get http://:10254/healthz delay=0s timeout=1s period=10s #success=1 #failure=3
    Environment:
      POD_NAME:       nginx-ingress-controller-8566746984-drcs6 (v1:metadata.name)
      POD_NAMESPACE:  kube-system (v1:metadata.namespace)
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from nginx-ingress-token-4nmpx (ro)
Conditions:
  Type           Status
  Initialized    True
  Ready          True
  PodScheduled   True
Volumes:
  nginx-ingress-token-4nmpx:
    Type:        Secret (a volume populated by a Secret)
    SecretName:  nginx-ingress-token-4nmpx
    Optional:    false
QoS Class:       BestEffort
Node-Selectors:  <none>
Tolerations:     node.kubernetes.io/not-ready:NoExecute for 300s
                 node.kubernetes.io/unreachable:NoExecute for 300s
Events:
  Type     Reason                 Age   From               Message
  ----     ------                 ----  ----               -------
  Normal   Scheduled              32m   default-scheduler  Successfully assigned nginx-ingress-controller-8566746984-drcs6 to minikube
  Normal   SuccessfulMountVolume  32m   kubelet, minikube  MountVolume.SetUp succeeded for volume "nginx-ingress-token-4nmpx"
  Normal   Pulling                32m   kubelet, minikube  pulling image "quay.io/kubernetes-ingress-controller/nginx-ingress-controller:0.19.0"
  Normal   Pulled                 31m   kubelet, minikube  Successfully pulled image "quay.io/kubernetes-ingress-controller/nginx-ingress-controller:0.19.0"
  Normal   Created                31m   kubelet, minikube  Created container
  Normal   Started                31m   kubelet, minikube  Started container
  Warning  Unhealthy              31m   kubelet, minikube  Readiness probe failed: HTTP probe failed with statuscode: 500

```
