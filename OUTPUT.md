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
