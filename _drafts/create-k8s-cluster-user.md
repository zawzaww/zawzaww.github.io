---
layout: post
title: "Configuring RBAC Bindings for a User on Kubernetes"
categories: [Kubernetes]
tags: [kubernetes, cluster, auth, rbac]
---

This article focuses on how to setup and create a user with Cluster Roles and Role Bindings using Kubernetes built-in RBAC authorization features. Then, generate a ServiceAccount token and then configure the kubeconfig file with the token and give access to the user. Then, a user or developer can login and access the Kubernetes cluster with the token or kubeconfig file using the [Kubernetes Dashboard](https://github.com/kubernetes/dashboard) (or) the [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux) command-line tool.

## Use Case

> If you are working with the team and want to give access to a user or developer with specific permissions on the Kubernetes cluster.

## Before We Begin

Make sure you have installed the following tools.

 - Kubernetes Cluster
 - The [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux) command-line tool (or) [Kubernetes Dashboard](https://github.com/kubernetes/dashboard)

## Create a User with RBAC Bindings

In this article, we will demonstrate how to create a service account, *charlie* with **engineer** role that has read-only permissions to access all resources on the Kubernetes cluster, except from Secrets resources.

Create a YAML file named `k8s-user-charlie.yaml` that includes and configures *ServiceAccount*, *ClusterRole*, and *ClusterRoleBinding* resources.

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: charlie
  namespace: kube-system
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: engineer
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
  name: rolebinding-charlie
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: engineer
subjects:
  - kind: ServiceAccount
    name: charlie
    namespace: kube-system
```

In the above RBAC configuration, the *engineer* `ClusterRole` specifies a set of permissions to access all resources of Kubernetes, except from Secrets resources, and then the `ClusterRoleBinding` assigned a `ServiceAccount` user *charlie* to the *engineer* role.

Learn more about the detailed information on the RBAC configuration in the following section.

### Understanding the RBAC Configuration

`ServiceAccount` Creates a user for login and access the Kubernetes cluster.

`ClusterRole` Specifies rules that represent a set of permissions.

  - `verbs` Specifies permissions to access Kubernetes resources. For example, *get*, *list*, *watch*, *patch* and etc..

    - `get` - Read individual resources or objects, like viewing pod details.

    - `list` - List multiple resources of a certain type, like listing all pods in a namespace.

    - `watch` - Observe resources for real-time updates, often used by controllers to track changes. For example, *kubectl get configmap --watch.*

    - `create` - Create a new resource or object, like creating a new pod or deployment or service. For example, *kubectl apply -f deployment.yaml.*

    - `delete` - Remove individual resources, like deleting a specific pod.

    - `update` - Update the entire object. An update operation replaces the entire resource specification. It overwrites the existing object with the new specification. For example, *kubectl apply -f deployment.yaml.*

    - `patch` - Apply a partial update to a resource. A patch operation modifies specific fields selectively without affecting the rest of the object.

      For example, `kubectl patch deployment nginx-server -p '{"spec": {"template": {"spec": {"containers": [{"name": "nginx", "image": "nginx:v2"}]}}}}')`

  - `apiGroups` Specifies Kubernetes API groups. For example, *Deployment* is included in the *apps* API group.

    To get Kubernetes API groups, run the `kubectl api-resources` command. Check the `APIVERSION` column and format is `<api-group/version>`.

    ```sh
     $ kubectl api-resources
     NAME                              SHORTNAMES                  APIVERSION                        NAMESPACED   KIND
     configmaps                        cm                          v1                                true         ConfigMap
     namespaces                        ns                          v1                                false        Namespace
     pods                              po                          v1                                true         Pod
     secrets                                                       v1                                true         Secret
     services                          svc                         v1                                true         Service
     daemonsets                        ds                          apps/v1                           true         DaemonSet
     deployments                       deploy                      apps/v1                           true         Deployment
     replicasets                       rs                          apps/v1                           true         ReplicaSet
     statefulsets                      sts                         apps/v1                           true         StatefulSet
    ```

  - `resources` Specifies which Kubernetes resources to access to the user. Same as above api groups, run the `kubectl api-resources` command and check the resource name in the `NAME` column. For example, *deployment*, *services* and so on.

`ClusterRoleBinding` Grants the permissions defined in the ClusterRole and assigned to the ServiceAccount user.

  - `roleRef.apiGroup`
    - Set the API group of the cluster role (rbac.authorization.k8s.io).

  - `roleRef.kind`
    - Set the resource name of the cluster role (ClusterRole).

  - `roleRef.name`
    - Set the name of the cluster role you configured. In this article, I created an *engineer* role.

  - `subjects.kind`
    - Set the resource name of service account. (ServiceAccount)

  - `subjects.name`
    - Set the ServiceAccount name you created. In this article, it's *charlie*.

  - `subjects.namespace`
    - Set the namespace of your installed ServiceAccount resource. In this article, *kube-system* namespace.

### Deploy RBAC Resources on Kubernetes

After configuring RBAC bindings in the `k8s-user-charlie.yaml` YAML file, deploy it with the `kubectl` command-line tool on the Kubernetes cluster.

```sh
$ kubect apply -f k8s-user-charlie.yaml
```

Output:
```sh
serviceaccount/charlie created
clusterrole.rbac.authorization.k8s.io/engineer created
clusterrolebinding.rbac.authorization.k8s.io/rolebinding-charlie created
```

Reference: [https://kubernetes.io/docs/reference/access-authn-authz/rbac](https://kubernetes.io/docs/reference/access-authn-authz/rbac)

## Create a ServiceAccount Token

Previously, we have created a service account `charlie` user in the *kube-system* namespace. Next, we will create a service account token that we need to login and access the Kubernetes cluster and also need to use it in the *kubeconfig* file.

Get the service account name you deployed previously.

```sh
$ kubectl get serviceaccounts --namespace kube-system
```

Output:

```sh
NAME                                     SECRETS   AGE
...
default                                  0         18d
svclb                                    0         18d
k8s-admin                                0         18d
kubernetes-dashboard-metrics-server      0         18d
kubernetes-dashboard                     0         18d
charlie                                  0         21m
```

Create a service account token for the `charlie` user.

```sh
$ kubectl create token charlie --duration=8760h --output yaml --namespace kube-system
```

Output:

```yaml
apiVersion: authentication.k8s.io/v1
kind: TokenRequest
metadata:
  creationTimestamp: "2024-11-25T04:13:16Z"
  name: charlie
  namespace: kube-system
spec:
  audiences:
  - https://kubernetes.default.svc.cluster.local
  - k3s
  boundObjectRef: null
  expirationSeconds: 31536000
status:
  expirationTimestamp: "2025-11-25T04:13:16Z"
  token: eyJhbGciOiJSUzI1NiIsImtpZCI6Ii04blMtX1BpVHBQUUNxbXMxSEI3bkxRU1ZfNkVIR09UZGNiazlaWEoyaHMifQ.eyJhdWQiOlsiaHR0cHM6Ly9rdWJlcm5ldGVzLmRlZmF1bHQuc3ZjLmNsdXN0ZXIubG9jYWwiLCJrM3MiXSwiZXhwIjoxNzY0MDQzOTk2LCJpYXQiOjE3MzI1MDc5OTYsImlzcyI6Imh0dHBzOi8va3ViZXJuZXRlcy5kZWZhdWx0LnN2Yy5jbHVzdGVyLmxvY2FsIiwia3ViZXJuZXRlcy5pbyI6eyJuYW1lc3BhY2UiOiJrdWJlLXN5c3RlbSIsInNlcnZpY2VhY2NvdW50Ijp7Im5hbWUiOiJjaGFybGllIiwidWlkIjoiMDAxOTYyNDUtNzhiNy00NzFkLThjODAtYWFhYWMyM2I2NjJjIn19LCJuYmYiOjE3MzI1MDc5OTYsInN1YiI6InN5c3RlbTpzZXJ2aWNlYWNjb3VudDprdWJlLXN5c3RlbTpjaGFybGllIn0.PokSrN-g4vz-9cl9d7_KuVl3UGh5q2Slww0G68uE4hrocSvrFizmCch4VkKCrzZ7anp9P3nWBvk8WVizo4nN5U_Wn3p-h7_nsvyTrJ7_FflNYS6w8fbfFVKl0vD31MVrpmj40DApkbIepnDKzKfvvNsf00zFoNyi2iB7iIgsrkpUDJyc-o-juHYSIdHwVdhlWSOxmvvq0kf0VITR5wPs5aw02GSUDt2FPxaw-wPFu-3_UrVWTJI0ZgI9D2zzuVDDTvipFn_huRTzPqJN6Q8uHT1dgfaQh86WS8ZqbHuL_oMAxhXLdRwtc07nAm-1lyV3ISjeIicqfli8PZ8IOUWDNQ
```

Make sure you configure `duration` when you create the service account token.

That means the token will expire based on the duration you configured. For example, I've set the duration to `8760h` (365 days) and created the service account token on November 25, 2024. That token will expire on November 25, 2025.

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

