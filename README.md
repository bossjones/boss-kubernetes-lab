# boss-kubernetes-lab
learning kubernetes

# Getting started

### Now that we have Homebrew installed, lets get Minikube, Virtualbox and Helm situated.

```
$ brew cask install minikube
$ brew cask install virtualbox
$ brew install kubernetes-helm

# autocompletion
$ minikube completion bash > /usr/local/etc/bash_completion.d/minikube-completion
```

### VMware Fusion commandline tools

```
# VMware Fusion command-line utils
export PATH=$PATH:"/Applications/VMware Fusion.app/Contents/Library"
```

Test it by running

```
➜  ~ vmrun list
Total running VMs: 1
/Users/me/.minikube/machines/minikube/minikube.vmx


➜  ~ vmrun listNetworkAdapters /Users/me/.minikube/machines/minikube/minikube.vmx
Total network adapters: 1
INDEX  TYPE         VMNET
0      nat          vmnet8


➜  ~ vmrun listPortForwardings vmnet8
Total port forwardings: 0
```

Configure docker environment

```
eval $(minikube docker-env)
```

# Kubernetes Dashboard

`minikube dashboard`


# Autocompletions

```
source <(kubectl completion bash)
source <(helm completion bash)
```

# Create minikube server

```
# start up minikube
minikube start --vm-driver="vmwarefusion" --cpus=4 --memory=6000 --v=7 --alsologtostderr

# See which subjects a cluster role is applied
kubectl get clusterrolebindings system:node --all-namespaces -o json

# Show Merged kubeconfig settings.
kubectl config view


# Display the current-context
kubectl config current-context


# Many add-ons currently run as the “default” service account in the kube-system namespace. To allow those add-ons to run with super-user access, grant cluster-admin permissions to the “default” service account in the kube-system namespace.

# NOTE:  Enabling this means the kube-system namespace contains secrets that grant super-user access to the API. (3rd most secure option)
kubectl create clusterrolebinding add-on-cluster-admin --clusterrole=cluster-admin --serviceaccount=kube-system:default


# OPTION 2 ( strongly discouraged )
# NOTE: This allows any user with read access
to secrets or the ability to create a pod to access super-user
credentials.
# WARNING: ONLY RUN THIS IF YOU KNOW WHAT YOU ARE DOING
# kubectl create clusterrolebinding serviceaccounts-cluster-admin \
  --clusterrole=cluster-admin \
  --group=system:serviceaccounts


# Display the current-context


minikube dashboard
```


# Components of a k8 cluster

* `kubelet`: The Kubelet acts as a bridge between the Kubernetes master and the nodes. It manages the pods and containers running on a machine. Kubelet translates each pod into its constituent containers and fetches individual container usage statistics from cAdvisor. It then exposes the aggregated pod resource usage statistics via a REST API.
* apiserver
* proxy
* controller-manager
* etcd
* scheduler

# Basics

| Term          | Definition    |
| ------------- |:-------------:|
|deployments| High-level construct that define an application|
|pods| Instances of a container in a deployment|
|services| Endpoints that export ports to the outside world|

# Terms

* `Role`: In the RBAC API, a role contains rules that represent a set of permissions. Permissions are purely additive (there are no “deny” rules). A role can be defined within a namespace with a `Role`, or cluster-wide with a `ClusterRole`.

Example Role:

```
kind: Role
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  namespace: default
  name: pod-reader
rules:
- apiGroups: [""] # "" indicates the core API group
  resources: ["pods"]
  verbs: ["get", "watch", "list"]
```

* `ClusterRole`: can be used to grant the same permissions as a `Role`, but because they are cluster-scoped, they can also be used to grant access to:

  * cluster-scoped resources (like nodes)
  * non-resource endpoints (like “/healthz”)
  * namespaced resources (like pods) across all namespaces (needed to run kubectl get pods --all-namespaces, for example)

Example ClusterRole:

```
kind: ClusterRole
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  # "namespace" omitted since ClusterRoles are not namespaced
  name: secret-reader
rules:
- apiGroups: [""]
  resources: ["secrets"]
  verbs: ["get", "watch", "list"]
```

* `RoleBinding and ClusterRoleBinding`: A role binding grants the permissions defined in a role to a user or set of users. It holds a list of subjects (users, groups, or service accounts), and a reference to the role being granted. Permissions can be granted within a namespace with a `RoleBinding`, or cluster-wide with a `ClusterRoleBinding`. A `RoleBinding` may reference a Role in the same namespace.

Example RoleBinding:

```
# This role binding allows "jane" to read pods in the "default" namespace.
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: read-pods
  namespace: default
subjects:
- kind: User
  name: jane # Name is case sensitive
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role #this must be Role or ClusterRole
  name: pod-reader # this must match the name of the Role or ClusterRole you wish to bind to
  apiGroup: rbac.authorization.k8s.io
```

* `ClusterRoleBinding`: Finally, a `ClusterRoleBinding` may be used to grant permission at the cluster level and in all namespaces.



Example ClusterRoleBinding:

```
# This cluster role binding allows anyone in the "manager" group to read secrets in any namespace.
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: read-secrets-global
subjects:
- kind: Group
  name: manager # Name is case sensitive
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: ClusterRole
  name: secret-reader
  apiGroup: rbac.authorization.k8s.io
```



`Service Account`: A service account provides an identity for processes that run in a Pod. [more](https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/) When you (a human) access the cluster (for example, using kubectl), you are authenticated by the apiserver as a particular User Account (currently this is usually admin, unless your cluster administrator has customized your cluster). Processes in containers inside pods can also contact the apiserver. When they do, they are authenticated as a particular Service Account (for example, default).


# helpers ( Install in dotfiles )

```
# kubectl and seeing (cluster)roles assigned to subjects
# SOURCE: https://stackoverflow.com/questions/43186611/kubectl-and-seeing-clusterroles-assigned-to-subjects

# $1 is kind (User, Group, ServiceAccount)
# $2 is name ("system:nodes", etc)
# $3 is namespace (optional, only applies to kind=ServiceAccount)
function getRoles() {
    local kind="${1}"
    local name="${2}"
    local namespace="${3:-}"

    kubectl get clusterrolebinding -o json | jq -r "
      .items[]
      |
      select(
        .subjects[]?
        |
        select(
            .kind == \"${kind}\"
            and
            .name == \"${name}\"
            and
            (if .namespace then .namespace else \"\" end) == \"${namespace}\"
        )
      )
      |
      (.roleRef.kind + \"/\" + .roleRef.name)
    "
}

$ getRoles Group system:authenticated
ClusterRole/system:basic-user
ClusterRole/system:discovery

$ getRoles ServiceAccount attachdetach-controller kube-system
ClusterRole/system:controller:attachdetach-controller
```

# Must read
* Kubernetes Concepts: https://kubernetes.io/docs/concepts/
* K8 core resources and operations: https://kubernetes.io/docs/concepts/overview/kubernetes-api/
* Pods: https://kubernetes.io/docs/concepts/workloads/pods/pod/
* Deployments: https://kubernetes.io/docs/concepts/workloads/controllers/deployment/
* Namespaces: https://kubernetes.io/docs/user-guide/namespaces/
* Secrets: https://kubernetes.io/docs/concepts/configuration/secret/
* Replicasets: https://kubernetes.io/docs/user-guide/replicasets/
* PersistentVolumes: https://kubernetes.io/docs/concepts/storage/volumes/
* ConfigMaps: https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/
* Nodes: https://kubernetes.io/docs/concepts/architecture/nodes/


# Example configs you'll need to bring up an app on k8

```
- namespace config
- 1 persistent volume config
- 2 deployment configs (MySQL + WordPress)
- 2 service configs (MySQL + WordPress)
- 1 ingress config
```


# Resources:

- https://itnext.io/kubernetes-base-config-for-nginx-ingress-cert-manager-helm-tiller-edf5645e04ef
- QUICKSTART: https://gist.github.com/F21/08bfc2e3592bed1e931ec40b8d2ab6f5
- https://docs.helm.sh/using_helm/#role-based-access-control
- https://kubernetes.io/docs/reference/access-authn-authz/rbac/#service-account-permissions
- https://docs.bitnami.com/kubernetes/how-to/configure-rbac-in-your-kubernetes-cluster/
- https://stackoverflow.com/questions/50042159/missingtiller-dial-tcp-127-0-0-18080-connect-connection-refused
- https://docs.bitnami.com/kubernetes/get-started-kubernetes/
- https://medium.com/@anthonyganga/getting-started-with-helm-tiller-in-kubernetes-part-one-3250aa99c6ac
- https://blog.because-security.com/t/minikube-on-mac-os-x-with-vmware-fusion-for-local-development-and-a-not-so-local-future/319
- https://github.com/Alfresco/acs-deployment/blob/master/docs/helm-deployment-minikube.md
- https://continuous.lu/2017/04/28/minikube-and-helm-kubernetes-package-manager/
- https://github.com/helm/charts/tree/master/incubator/elasticsearch
- https://github.com/ramitsurana/awesome-kubernetes
- https://blog.sourcerer.io/a-kubernetes-quick-start-for-people-who-know-just-enough-about-docker-to-get-by-71c5933b4633
- http://127.0.0.1:63569/api/v1/namespaces/kube-system/services/http:kubernetes-dashboard:/proxy/#!/overview?namespace=default
- https://medium.com/logojoy-engineering/the-worlds-longest-wordpress-deployment-5eda086bbc62
- https://itnext.io/kubernetes-base-config-for-nginx-ingress-cert-manager-helm-tiller-edf5645e04ef


# Demo repos
- [LevelUpEducation/kubernetes-demo](git@github.com:LevelUpEducation/kubernetes-demo.git)
