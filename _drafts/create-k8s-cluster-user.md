---
layout: post
title: "Creating a User with RBAC Bindings for access Kubernetes Cluster"
categories: [Kubernetes]
---

This blog focuses on how to setup and create a Kubernetes Cluster user with Cluster Role and Role Bindings
using Kubernetes built in RBAC Authorization features and then, configure `kubeconfig` with `ServiceAccount` user token and give access it to user.

## Prerequisites

Before we begin, make sure you setup Kubernetes Cluster and following tools.

 - [Kubeconfig](https://kubernetes.io/docs/concepts/configuration/organize-cluster-access-kubeconfig)
 - [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux) client tool (or) [Kubernetes dashboard](https://github.com/kubernetes/dashboard)

## Create a User with RBAC Authorization

Firstly, we need to create a `ServiceAccount`, `ClusterRole` and `ClusterRoleBinding` resource and install it on Kubernetes.

In this documentation,
we will demonstrate to create a normal cluster user with `engineer` role that has read only permissions to access Kubernetes Cluster.

### Understanding the RBAC Configuration

`ServiceAccount` creates a user that we'll use in kubeconfig later.

`ClusterRole` defines rules that represents a set of permissions.

 - `verbs` define permissions to access Kubernetes resources. For example, `get`, `list`, `watch`, `patch` and etc..
 - `apiGroups` define Kubernetes API groups. Fro example, `ingress` is included in `networking.k8s.io` API group.
 - `resources` define which Kubernetes resources to access to user. For example, `daemonsets`, `services` and etc..

`ClusterRoleBinding` grants the permissions defined in `developer` ClusterRole to `k8s-dev` user.

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: k8s-dev
  namespace: kube-system
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: developer
rules:
  - verbs:
      - get
      - list
      - watch
    apiGroups:
      - ''
    resources:
      - configmaps
      - endpoints
      - persistentvolumeclaims
      - pods
      - replicationcontrollers
      - replicationcontrollers/scale
      - services
      - nodes
      - persistentvolumeclaims
      - persistentvolumes
  - verbs:
      - get
      - list
      - watch
    apiGroups:
      - ''
    resources:
      - bindings
      - events
      - limitranges
      - namespaces/status
      - pods/log
      - pods/status
      - replicationcontrollers/status
      - resourcequotas
      - resourcequotas/status
  - verbs:
      - get
      - list
      - watch
    apiGroups:
      - ''
    resources:
      - namespaces
  - verbs:
      - get
      - list
      - watch
    apiGroups:
      - apps
    resources:
      - daemonsets
      - deployments
      - deployments/scale
      - replicasets
      - replicasets/scale
      - statefulsets
  - verbs:
      - get
      - list
      - watch
    apiGroups:
      - autoscaling
    resources:
      - horizontalpodautoscalers
  - verbs:
      - get
      - list
      - watch
    apiGroups:
      - batch
    resources:
      - cronjobs
      - jobs
  - verbs:
      - get
      - list
      - watch
    apiGroups:
      - extensions
    resources:
      - daemonsets
      - deployments
      - deployments/scale
      - ingresses
      - networkpolicies
      - replicasets
      - replicasets/scale
      - replicationcontrollers/scale
  - verbs:
      - get
      - list
      - watch
    apiGroups:
      - policy
    resources:
      - poddisruptionbudgets
  - verbs:
      - get
      - list
      - watch
    apiGroups:
      - networking.k8s.io
    resources:
      - networkpolicies
      - ingresses
  - verbs:
      - get
      - list
      - watch
    apiGroups:
      - storage.k8s.io
    resources:
      - storageclasses
      - volumeattachments
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: k8s-dev
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: developer
subjects:
  - kind: ServiceAccount
    name: k8s-dev
    namespace: kube-system
```

### Deploy RBAC Resources on Kubernetes

Then, install resources on Kubernetes Cluster.

```sh
$ kubect apply -f k8s-dev-user.yaml --namespace kube-system
```

Ref: [https://kubernetes.io/docs/reference/access-authn-authz/rbac](https://kubernetes.io/docs/reference/access-authn-authz/rbac)

## Create ServiceAccount Token

Previously, we've created a `ServiceAccount` also known as `k8s-dev` User.
Next, we need to create ServiceAccount token that we will use in kubeconfig file to access Kubernetes cluster.

Create a ServiceAccount token for `k8s-dev` user.

```sh
$ kubectl create token k8s-dev --duration=8760h --output yaml --namespace kube-system
```

```yaml
apiVersion: authentication.k8s.io/v1
kind: TokenRequest
metadata:
  creationTimestamp: "2024-01-10T03:58:19Z"
  name: k8s-dev
  namespace: kube-system
spec:
  audiences:
  - https://kubernetes.default.svc.cluster.local
  - k3s
  boundObjectRef: null
  expirationSeconds: 31536000
status:
  expirationTimestamp: "2025-01-10T03:58:19Z"
  token: eyJhbGciOiJSUzI1NiIsImtpZCI6Ii04blM..
```

Make sure you configure `duration` when you create ServiceAccount tokens.

## Configure Kubeconfig with ServiceAccount Token

When you've setup Kubernetes cluster, Kubernetes sets default`kubeconfig` file
and stored file location depends on Kubernetes distribution.

In this `kubeconfig` file, we will set and replace default `admin` user with `k8s-dev` user and token.
Then, users can access Kubernetes cluster as a read only or view only user.

```
apiVersion: v1
kind: Config
clusters:
- name: "k3s-dev-cluster"
  cluster:
    server: "https://127.0.0.1:6443"
    certificate-authority-data: "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUJlRENDQ\
      VIrZ0F3SUJBZ0lCQURBS0JnZ3Foa2pPUFFRREFqQWtNU0l3SUFZRFZRUUREQmx5YTJVeUxYTmwKY\
      25abGNpMWpZVUF4TmpVNU5qazBNamN3TUI0WERUSXlNRGd3TlRFd01URXhNRm9YRFRNeU1EZ3dNa\
      kV3TVRFeApNRm93SkRFaU1DQUdBMVVFQXd3WmNtdGxNaTF6WlhKMlpYSXRZMkZBTVRZMU9UWTVOR\
      EkzTURCWk1CTUdCeXFHClNNNDlBZ0VHQ0NxR1NNNDlBd0VIQTBJQUJDZVlxRGQ0M2UwNXFQU21pd\
      UFzWWNWRWdtRXZRbFUwSm9ZSWJZOG4KZndORjQwZXUyZ0tRNGRNSHp3RWtmUjNvT2g4VWY5YUM3Y\
      mRYWFVjZGw3UVFqb09qUWpCQU1BNEdBMVVkRHdFQgovd1FFQXdJQ3BEQVBCZ05WSFJNQkFmOEVCV\
      EFEQVFIL01CMEdBMVVkRGdRV0JCVEYyNTlhbEZlSlprSGtNV1g4ClVqSmM5YWZRampBS0JnZ3Foa\
      2pPUFFRREFnTkhBREJFQWlBM3Z2UEdscGxhbFljN2R1aW9sc0thUzZES1Vzem0KWjNSS1dKWmdTa\
      TRhL1FJZ0Z2L29ESlY2TUN0aGlIQjZhMFRFZG1COGx0dEs5KzREUnkwVFppR09xdFE9Ci0tLS0tR\
      U5EIENFUlRJRklDQVRFLS0tLS0K"
contexts:
- name: "k3s-dev-cluster"
  context:
    user: "k8s-dev"
    cluster: "k3s-dev-cluster"
current-context: "k3s-dev-cluster"
users:
- name: "k8s-dev"
  user:
    token: eyJhbGciOiJSUzI1NiIsImtpZCI6Ii04blM..
```

Make sure you update created `ServiceAccount` user name and user token in your `kuebconfig` file like this:

```
...
users:
- name: "k8s-dev"
  user:
    token: eyJhbGciOiJSUzI1NiIsImtpZCI6Ii04blM..
```

Then, you can access Kubernetes Cluster with this `kubeconfig` file.

## Testing Kubeconfig and Demo

In this section, we will demonstrate created ServiceAccount tokens are working or not with `kubectl` tool.

Before you run kubectl, make sure you export `KUBECONFIG` to your `kubeconfig` file path.

For example, I've setup `KUBECONFIG` env like this

```
[zawzaw@fedora-linux:~]$ export KUBECONFIG=~/kubernetes/kubeconfigs/k3s-dev-kubeconfig
```

```
[zawzaw@fedora-linux:~]$ echo $KUBECONFIG
/home/zawzaw/kubernetes/kubeconfigs/k3s-dev-kubeconfig
```

### Testing List Pods

Firstly, try to test listing Pods.

```sh
$ kubectl get pods --namespace dev
```

```
NAME                                                          READY   STATUS      RESTARTS         AGE
apisix-6cffd9b895-h4xgw                                       1/1     Running     0                27d
apisix-dashboard-65996664fd-xks9j                             1/1     Running     0                27d
battery-management-api-dev-7649b4f44d-t8nw5                   2/2     Running     0                3h
battery-management-api-dev-mysql-update-27930030-4g67k        0/1     Completed   0                27d
battery-management-ui-dev-86bf794f5-b96cs                     2/2     Running     0                3h
bms-lithium-server-dev-577c79c56c-zwqgm                       1/1     Running     0                3h
cpe-lookup-api-dev-77bf9c4b7f-g4swv                           1/1     Running     0                3h
cpe-lookup-ui-dev-6d548c7bf4-cbrg5                            1/1     Running     0                3h
fiber-maps-api-dev-79b8458f5b-qppkz                           2/2     Running     0                179m
fiber-maps-api-dev-79b8458f5b-svbx6                           2/2     Running     0                179m
...
```

### Testing Delete Pods

We have not allowed `patch` permission in `developer` Cluster Role.
So, it cannot be deleted Kubernetes resources such as `Pods` and `ConfigMap` by `k8s-dev` user.

Test it by running `kubect delete <resource>`.

For example,

```sh
$ kubectl delete pod apisix-6cffd9b895-h4xgw --namespace dev
```

Then, it shows the following,
```
Error from server (Forbidden): pods "apisix-6cffd9b895-h4xgw" is forbidden: User "system:serviceaccount:kube-system:k8s-dev" cannot delete resource "pods" in API group "" in the namespace "dev"
```

### Testing List Secrets

We have also not allowed `get`, `list`, `watch` permissions for `Secrets` resource.
So, it cannot be viewed `Secrets` by `k8s-dev` user.

Test it by running `kubectl get secretes`.

For example,

```sh
$ kubectl get secrets --namespace dev
```

Then, it shows the following,

```
Error from server (Forbidden): secrets is forbidden: User "system:serviceaccount:kube-system:k8s-dev" cannot list resource "secrets" in API group "" in the namespace "dev"
```

Finally, we can confirm that Cluster Role and Role Bindings are working properly.

