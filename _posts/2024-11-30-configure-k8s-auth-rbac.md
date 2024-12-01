---
layout: post
title: "Configuring RBAC Role Bindings for a User on Kubernetes"
categories: [Kubernetes]
tags: [kubernetes, cluster, auth, rbac]
image:
  src: /assets/images/featured-images/img_kubernetes_logo_horizontal.png
  description: "Official Kubernetes Logo by Kubernetes Community"
---

This article focuses on how to create a user and configure cluster roles and role bindings for that user using Kubernetes built-in RBAC authorization features. Basically, in Kubernetes, we can use the service account as a user, but it is like a non-human user.

Generally, every Kubernetes cluster has the default admin *kubeconfig* file. We usually use this admin *kubeconfig* file to log in to, access, and manage the Kubernetes cluster. We can generate a service account token and assign this service account or user to a specific cluster role, and then configure the *kubeconfig* file with its token and give access to the user.

Then, a user or developer can log in to and access the Kubernetes cluster with the token or kubeconfig file using the [Kubernetes Dashboard](https://github.com/kubernetes/dashboard) (or) the [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux) command-line tool.

## Use Case

> Working with the team and want to give access to a user or developer with specific permissions on the Kubernetes cluster.

> For example, if you want to give access to a user with read-only access permissions.

## Objectives

 - Explore built-in RBAC authorization features on Kubernetes.
 - How to configure a service account, cluster roles and role bindings.
 - Learn a deep dive into RBAC verbs and how to grant permissions to a user.
 - How to generate a service account token for the user and use it in the *kubeconfig* file to access the Kubernetes cluster.

## Before We Begin

Make sure you have installed the following tools.

 - Kubernetes Cluster
 - The [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux) command-line tool (or) [Kubernetes Dashboard](https://github.com/kubernetes/dashboard)

## Creating a User with RBAC Bindings

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

In the above RBAC configuration, the *engineer* `ClusterRole` specifies a set of permissions to access all resources of Kubernetes, except from Secrets, and then the `ClusterRoleBinding` assigned a `ServiceAccount` user *charlie* to the *engineer* role.

Learn more about the detailed information on the RBAC configuration in the next section.

## Understanding the RBAC Configuration

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

Reference: [https://kubernetes.io/docs/reference/access-authn-authz/rbac](https://kubernetes.io/docs/reference/access-authn-authz/rbac)

## Generating a ServiceAccount Token

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

## Deploying Kubernetes Dashboard UI

![kubernetes-dashboard](/assets/images/screenshots/img_screenshot_k8s_dashboard.png)

Before we use the service account token, make sure you deployed the [Kubernetes Dashboard](https://github.com/kubernetes/dashboard), a general-purpose web UI for Kubernetes clusters. In this article, we will use the Kubernetes dashboard to manage and monitor the Kubernetes cluster.

You can use the Helm package manager to deploy the Kubernetes dashboard. Please, see [https://github.com/kubernetes/dashboard/blob/master/README.md#installation](https://github.com/kubernetes/dashboard/blob/master/README.md#installation).

Add the kubernetes-dashboard Helm repository.

```sh
$ helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard
```

Deploy the Kubernetes dashboard UI using the kubernetes-dashboard Helm chart.

```sh
$ helm install kubernetes-dashboard \
  kubernetes-dashboard/kubernetes-dashboard \
  --create-namespace \
  --namespace kubernetes-dashboard
```

Read more configuration details on the ArtifactHub, [https://artifacthub.io/packages/helm/k8s-dashboard/kubernetes-dashboard](https://artifacthub.io/packages/helm/k8s-dashboard/kubernetes-dashboard)

## Using ServiceAccount Tokens

We have **two options** to log in to the Kubernetes dashboard to manage and monitor the Kubernetes cluster. You can also use the *kubectl* client tool to interact with the Kubernetes cluster.

 - ServiceAccount Token (Only)
 - Kubeconfig with ServiceAccount Token

### ServiceAccount Token (Only)

Make sure you have deployed the Kubernetes dashboard UI on the Kubernete cluster. In the previous section, we have generated the service account token. We can simply use this token to log in to the Kubernetes dashboard.

Previously, a generated service account token:

```yaml
...
status:
  expirationTimestamp: "2025-11-25T04:13:16Z"
  token: eyJhbGciOiJSUzI1NiIsImtpZCI6Ii04blMtX1BpVHBQUUNxbXMxSEI3bkxRU1ZfNkVIR09UZGNiazlaWEoyaHMifQ.eyJhdWQiOlsiaHR0cHM6Ly9rdWJlcm5ldGVzLmRlZmF1bHQuc3ZjLmNsdXN0ZXIubG9jYWwiLCJrM3MiXSwiZXhwIjoxNzY0MDQzOTk2LCJpYXQiOjE3MzI1MDc5OTYsImlzcyI6Imh0dHBzOi8va3ViZXJuZXRlcy5kZWZhdWx0LnN2Yy5jbHVzdGVyLmxvY2FsIiwia3ViZXJuZXRlcy5pbyI6eyJuYW1lc3BhY2UiOiJrdWJlLXN5c3RlbSIsInNlcnZpY2VhY2NvdW50Ijp7Im5hbWUiOiJjaGFybGllIiwidWlkIjoiMDAxOTYyNDUtNzhiNy00NzFkLThjODAtYWFhYWMyM2I2NjJjIn19LCJuYmYiOjE3MzI1MDc5OTYsInN1YiI6InN5c3RlbTpzZXJ2aWNlYWNjb3VudDprdWJlLXN5c3RlbTpjaGFybGllIn0.PokSrN-g4vz-9cl9d7_KuVl3UGh5q2Slww0G68uE4hrocSvrFizmCch4VkKCrzZ7anp9P3nWBvk8WVizo4nN5U_Wn3p-h7_nsvyTrJ7_FflNYS6w8fbfFVKl0vD31MVrpmj40DApkbIepnDKzKfvvNsf00zFoNyi2iB7iIgsrkpUDJyc-o-juHYSIdHwVdhlWSOxmvvq0kf0VITR5wPs5aw02GSUDt2FPxaw-wPFu-3_UrVWTJI0ZgI9D2zzuVDDTvipFn_huRTzPqJN6Q8uHT1dgfaQh86WS8ZqbHuL_oMAxhXLdRwtc07nAm-1lyV3ISjeIicqfli8PZ8IOUWDNQ
```

Go to the Kubernetes dashboard UI --> **Token** --> Enter token --> Sign in

![screenshot-k8s-dashboard-login](/assets/images/screenshots/img_screenshot_k8s_dashboard_login.png)

Then, you will see *system:serviceaccount:kube-system:charlie* service account as a logged-in user in the profile.

![screenshot-user-charlie](/assets/images/screenshots/img_screenshot_k8s_user_charlie.png)

### Kubeconfig with ServiceAccount Token

When you've bootstrapped and setup a Kubernetes cluster, it sets a default *kubeconfig* file. But, file location depends on the Kubernetes distribution. For example, in the K3s Kubernetes distribution, the default *kubeconfig* file location is `/etc/rancher/k3s/k3s.yaml`.

We will create and clone a *kubeconfig* file named `kubeconfig-charlie` from the original K3s kubeconfig `/etc/rancher/k3s/k3s.yaml` file. Then, we will set and replace the default *admin* user with *Charlie* and its token. Then, *Charlie* can access the Kubernetes cluster as a read-only or view-only user using the *kubeconfig* file.

```yaml
apiVersion: v1
kind: Config
clusters:
- cluster:
    certificate-authority-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUJkekNDQVIyZ0F3SUJBZ0lCQURBS0JnZ3Foa2pPUFFRREFqQWpNU0V3SHdZRFZRUUREQmhyTTNNdGMyVnkKZG1WeUxXTmhRREUyTmpBd05qRTFNVFV3SGhjTk1qSXdPREE1TVRZeE1UVTFXaGNOTXpJd09EQTJNVFl4TVRVMQpXakFqTVNFd0h3WURWUVFEREJock0zTXRjMlZ5ZG1WeUxXTmhRREUyTmpBd05qRTFNVFV3V1RBVEJnY3Foa2pPClBRSUJCZ2dxaGtqT1BRTUJCd05DQUFSUW1wQnBRY3lhL0dUa2FPL2JLSGNHc2tac2M0UHpaNElYc3ZQVVQzMUoKNjNVb3AxQXZ4WlhObDhoRWk1ZkxFL2s1WC8zSnNreE5aSHJmSHVoY0lKODVvMEl3UURBT0JnTlZIUThCQWY4RQpCQU1DQXFRd0R3WURWUjBUQVFIL0JBVXdBd0VCL3pBZEJnTlZIUTRFRmdRVWlJUkN0QU50VEZPR3cycEZ1ZGxQCmhZWXIzQTR3Q2dZSUtvWkl6ajBFQXdJRFNBQXdSUUloQUtPTUVNRjVmaUxkc0JxV0lpL0k5VnNJQS9BWEVLWEUKVXhSajJYQ2szUnQ4QWlBcDQ4SFZjRytodXIvS2hZaTVnSUZ3Vk1wUGYyWHV3WE1SRk5wV09kZEZ6Zz09Ci0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0K
    server: https://<k3s_server_address>:6443
  name: k3s-dev-cluster
contexts:
- context:
    cluster: k3s-dev-cluster
    user: charlie
  name: k3s-dev-cluster
current-context: k3s-dev-cluster
preferences: {}
- name: charlie
  user:
    token: eyJhbGciOiJSUzI1NiIsImtpZCI6Ii04blMtX1BpVHBQUUNxbXMxSEI3bkxRU1ZfNkVIR09UZGNiazlaWEoyaHMifQ.eyJhdWQiOlsiaHR0cHM6Ly9rdWJlcm5ldGVzLmRlZmF1bHQuc3ZjLmNsdXN0ZXIubG9jYWwiLCJrM3MiXSwiZXhwIjoxNzY0MDQzOTk2LCJpYXQiOjE3MzI1MDc5OTYsImlzcyI6Imh0dHBzOi8va3ViZXJuZXRlcy5kZWZhdWx0LnN2Yy5jbHVzdGVyLmxvY2FsIiwia3ViZXJuZXRlcy5pbyI6eyJuYW1lc3BhY2UiOiJrdWJlLXN5c3RlbSIsInNlcnZpY2VhY2NvdW50Ijp7Im5hbWUiOiJjaGFybGllIiwidWlkIjoiMDAxOTYyNDUtNzhiNy00NzFkLThjODAtYWFhYWMyM2I2NjJjIn19LCJuYmYiOjE3MzI1MDc5OTYsInN1YiI6InN5c3RlbTpzZXJ2aWNlYWNjb3VudDprdWJlLXN5c3RlbTpjaGFybGllIn0.PokSrN-g4vz-9cl9d7_KuVl3UGh5q2Slww0G68uE4hrocSvrFizmCch4VkKCrzZ7anp9P3nWBvk8WVizo4nN5U_Wn3p-h7_nsvyTrJ7_FflNYS6w8fbfFVKl0vD31MVrpmj40DApkbIepnDKzKfvvNsf00zFoNyi2iB7iIgsrkpUDJyc-o-juHYSIdHwVdhlWSOxmvvq0kf0VITR5wPs5aw02GSUDt2FPxaw-wPFu-3_UrVWTJI0ZgI9D2zzuVDDTvipFn_huRTzPqJN6Q8uHT1dgfaQh86WS8ZqbHuL_oMAxhXLdRwtc07nAm-1lyV3ISjeIicqfli8PZ8IOUWDNQ
```

Previously, we have created a service account named `charlie` and generated its token. We will use them in the *kubeconfig* file. Make sure you set the service account **user** name and its **token** in the *kubeconfig-charlie* file like this.

```yaml
...
contexts:
- context:
    cluster: k3s-dev-cluster
    user: charlie
  name: k3s-dev-cluster
...
users:
- name: charlie
  user:
    token: eyJhbGciOiJSUzI1NiIsImtpZCI6Ii04blMtX1BpVHBQUUNxbXMxSEI3bkxRU1ZfNkVIR09UZGNiazlaWEoyaHMifQ.eyJhdWQiOlsiaHR0cHM6Ly9rdWJlcm5ldGVzLmRlZmF1bHQuc3ZjLmNsdXN0ZXIubG9jYWwiLCJrM3MiXSwiZXhwIjoxNzY0MDQzOTk2LCJpYXQiOjE3MzI1MDc5OTYsImlzcyI6Imh0dHBzOi8va3ViZXJuZXRlcy5kZWZhdWx0LnN2Yy5jbHVzdGVyLmxvY2FsIiwia3ViZXJuZXRlcy5pbyI6eyJuYW1lc3BhY2UiOiJrdWJlLXN5c3RlbSIsInNlcnZpY2VhY2NvdW50Ijp7Im5hbWUiOiJjaGFybGllIiwidWlkIjoiMDAxOTYyNDUtNzhiNy00NzFkLThjODAtYWFhYWMyM2I2NjJjIn19LCJuYmYiOjE3MzI1MDc5OTYsInN1YiI6InN5c3RlbTpzZXJ2aWNlYWNjb3VudDprdWJlLXN5c3RlbTpjaGFybGllIn0.PokSrN-g4vz-9cl9d7_KuVl3UGh5q2Slww0G68uE4hrocSvrFizmCch4VkKCrzZ7anp9P3nWBvk8WVizo4nN5U_Wn3p-h7_nsvyTrJ7_FflNYS6w8fbfFVKl0vD31MVrpmj40DApkbIepnDKzKfvvNsf00zFoNyi2iB7iIgsrkpUDJyc-o-juHYSIdHwVdhlWSOxmvvq0kf0VITR5wPs5aw02GSUDt2FPxaw-wPFu-3_UrVWTJI0ZgI9D2zzuVDDTvipFn_huRTzPqJN6Q8uHT1dgfaQh86WS8ZqbHuL_oMAxhXLdRwtc07nAm-1lyV3ISjeIicqfli8PZ8IOUWDNQ
```

Then, you can access the Kubernetes cluster with this *kubeconfig* file using the Kubernetes dashboard or kubectl command-line tool.

To log in to the Kubernetes dashboard with the *kubeconfig* file, same as in the previous section, log in with the token.

Go to the Kubernetes dashboard --> **Kubeconfig** --> Choose the kubeconfig file --> Sign in

![screenshot-k8s-kubeconfig](/assets/images/screenshots/img_screenshot_k8s_kubeconfig.png)

## Demo: Testing Configured RBAC Bindings

In this section, we will demonstrate whether service account tokens with RBAC role bindings are working or not. We can use both the Kubernetes dashboard UI and the kubectl command-line tool to interact with the Kubernetes cluster.

### Listing Pods from All Namespaces

Firstly, we need to set the `KUBECONFIG` environment variable to the *kubeconfig* file if you want to use the kubectl command-line tool. For example,

```sh
$ export KUBECONFIG=~/.kube/kubeconfig-charlie
```

Then, we can verify the current context and cluster with kubectl.

```sh
$ kubectl config view
```

Output:

```sh
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: DATA+OMITTED
    server: https://<k3s_server_address>:6443
  name: k3s-dev-cluster
contexts:
- context:
    cluster: k3s-dev-cluster
    user: charlie
  name: k3s-dev-cluster
current-context: k3s-dev-cluster
kind: Config
preferences: {}
users:
- name: charlie
  user:
    token: REDACTED
```

We will list Pods from all namespaces with the kubectl tool. (Or) If you want to use the dashboard, go to the Kubernetes dashboard UI --> Pods --> Select *All namespaces*

```sh
$ kubectl get pods --all-namespaces
```

Output:
```sh
NAMESPACE           NAME                                                              READY   STATUS                  RESTARTS        AGE
kube-system         svclb-loki-stack-fccf98b8-g596j                                   1/1     Running                 1 (15d ago)     24d
kube-system         svclb-coredns-infra-9b5a1b8e-t7zvr                                2/2     Running                 2 (15d ago)     141d
kube-system         svclb-chatwoot-6f5e1870-qs8nt                                     1/1     Running                 1 (15d ago)     173d
kube-system         svclb-ingress-nginx-controller-9eb0868a-76x45                     5/5     Running                 5 (15d ago)     48d
kube-system         svclb-coredns-infra-9b5a1b8e-jllth                                2/2     Running                 2 (15d ago)     67d
kube-system         svclb-ingress-nginx-controller-9eb0868a-gnfzp                     5/5     Running                 5 (15d ago)     48d
dev                 chatwoot-client-7c5464856d-p2xdd                                  1/1     Running                 1 (15d ago)     67d
kube-system         svclb-chatwoot-6f5e1870-c2sfg                                     1/1     Running                 1 (15d ago)     67d
kube-system         svclb-loki-stack-fccf98b8-8kdgf                                   1/1     Running                 1 (15d ago)     24d
kube-system         svclb-kafka-infra-controller-0-external-8796a87b-rq7d8            1/1     Running                 1 (15d ago)     67d
monitoring-system   kube-prometheus-stack-prometheus-node-exporter-zrlnh              1/1     Running                 2 (15d ago)     67d
openebs             openebs-ndm-operator-7ddccf59c4-64664                             1/1     Running                 1 (15d ago)     56d
monitoring-system   kube-prometheus-stack-prometheus-node-exporter-rx4cp              1/1     Running                 9 (15d ago)     471d
argocd              argocd-notifications-controller-f95dc686f-tprcj                   1/1     Running                 1 (15d ago)     56d
argocd              argocd-dex-server-9595746ff-h7rcp                                 1/1     Running                 1 (15d ago)     56d
kube-system         svclb-loki-stack-fccf98b8-nz6hb                                   1/1     Running                 1 (15d ago)     24d
loki-stack          loki-stack-promtail-sf52l                                         1/1     Running                 1 (15d ago)     67d
kube-system         svclb-kafka-infra-controller-0-external-8796a87b-wdbrh            1/1     Running                 2 (15d ago)     173d
openebs             openebs-localpv-provisioner-686b564b5d-7llqf                      1/1     Running                 1 (15d ago)     56d
```

You can also list any other Kubernetes resources like *Deployments*, *DemonSets*, *StatefulSets*, *ConfigMaps*, *Services*, *Ingresses*, and so on. And note that we have also allowed to view Pods logs.

### Deleting or Restarting Pods

We will also test deleting or restarting the Pod resources with the kubectl client tool.
(Or)
If you want to use the dashboard, go to the Kubernetes dashboard UI --> Pods --> Select Namespace --> Click any Pod --> Delete resource

For example,

```sh
$ kubectl delete pod kube-prometheus-stack-prometheus-node-exporter-qt44p --namespace monitoring-system
```

Output:
```sh
Error from server (Forbidden): pods "kube-prometheus-stack-prometheus-node-exporter-qt44p" is forbidden: User "system:serviceaccount:kube-system:charlie" cannot delete resource "pods" in API group "" in the namespace "monitoring-system"
```

You cannot delete or restart Pods because we are ONLY allowed to *get*, *list* and *watch* the API resources such as Pods, ConfigmMaps, Services, and so on in the default API group in the *engineer* ClusterRole that binds to the *charlie* user also known as service account.

### Listing and Viewing Secrets

We will also test listing or viewing the Secret resources with the kubectl client tool.
(Or)
If you want to use the dashboard, go to the Kubernetes dashboard UI --> Secrets --> Select any namespace

For example,

```sh
$ kubectl get secrets --all-namespaces
```

Output:

```sh
Error from server (Forbidden): secrets is forbidden: User "system:serviceaccount:kube-system:charlie" cannot list resource "secrets" in API group "" at the cluster scope
```

You cannot also list or view the Secret resources because we have not allowed to *list* the Secret resources in the default API group in the *engineer* ClusterRole that binds to the *charlie* user also known as service account. So, Charlie cannot list the Secret resources.

Finally, we can confirm that the *charlie* ServiceAccount with ClusterRole and Role Bindings configuration are working properly.

