---
layout: post
title: "Building a Kubernetes Helm Chart from Scratch"
categories: [Kubernetes]
tags: [kubernetes, helm, chart]
image:
  src: /assets/images/featured-images/img_helm_kubernetes.png
  description: Helm Official Logo by Helm Community
---

In this blog post, I will share about writing Kubernetes Helm chart, YAML-based Helm template language, Helm chart development tips and focus on how to write a simple Helm Chart step by step for an application to deploy on Kubernetes and how to debug Helm templates locally. I will also demostrate with simple containerized Python Flask application to write Helm Chart and deploy it on Kubernetes cluster.

## Prerequisites
 - [Kubernetes](https://kubernetes.io) cluster
 - [Helm](https://helm.sh) Kubernetes package manager tool
 - Kubernetes Basics
   > You need to understand basic [Kubernetes objects](https://kubernetes.io/docs/concepts/overview/working-with-objects/kubernetes-objects) and [Workloads resources](https://kubernetes.io/docs/concepts/workloads). If you are not fimiliar with Kubernetes, you can learn basics with [Kubernetes Basics](https://kubernetes.io/docs/tutorials/kubernetes-basics) interactive tutorial.

## Introduction to Helm
Basically, [Helm](https://helm.sh) is a Kubernetes package manager that manages and deploys Helm charts.

[Helm Charts](https://artifacthub.io) are collection and packages of pre-configured application ressources which can be deployed as
one unit on Kubernetes. Helm charts help you **define**, **install**, **upgrade**, **rollback** and **deploy** applications easily on Kubernetes cluster.

Official Website: [https://helm.sh](https://helm.sh)

## Setup Local Kubernetes Cluster
In this article, I will use [minikube](https://minikube.sigs.k8s.io/docs) for setup local Kubernetes cluster on my Fedora Linux system.
You can use any other tools for setup Kubernetes cluster.

Download minikube CLI tool, it depends on your Operating System.

Please, see [https://minikube.sigs.k8s.io/docs/start](https://minikube.sigs.k8s.io/docs/start)

```sh
$ curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
```

Install minikube:

```sh
$ sudo install minikube-linux-amd64 /usr/local/bin/minikube
```

Start local minikube Kubernetes cluster with containerd:

```sh
$ minikube start --container-runtime=containerd
```

Check minikube status:

```sh
[zawzaw@redhat-linux:~]$ minikube status
minikube
type: Control Plane
host: Running
kubelet: Running
apiserver: Running
kubeconfig: Configured
```

## Installation Helm
To install Helm with script, run simply like this:

```sh
$ curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
```
```sh
$ chmod +x get_helm.sh && ./get_helm.sh
```

 (OR)

You can install Helm via package manager tools:
 - [https://helm.sh/docs/intro/install/#from-apt-debianubuntu](https://download.lineageos.org)
 - [https://helm.sh/docs/intro/install/#from-snap](https://helm.sh/docs/intro/install/#from-snap)

## Containerize an application
Before we write Kubernetes Helm chart, we need to containerize for your web application.

In this article, I will use open sourced pod-info-app: [https://gitlab.com/gitops-argocd-demo/webapp](https://gitlab.com/gitops-argocd-demo/webapp)
simple Python Flask application to demonstrate writing Helm chart and deploy it on Kubernetes cluster.

Download `pod-info-app` Git repository:

```sh
$ git clone https://gitlab.com/gitops-argocd-demo/webapp.git pod-info-app
```

This app application author has already written `Dockerfile` but we can update and customize `Dockerfile`
to update Python version and run gunicorn server with specific app user, instead of running container as root user.

Update port number in `PROJECT_ROOT/gunicorn-cfg.py` file like this:

```py
# -*- encoding: utf-8 -*-
bind = '0.0.0.0:8080'
workers = 1
accesslog = '-'
loglevel = 'debug'
capture_output = True
```

Update and customize `PROJECT_ROOT/Dockefile` file to run container with specific app user:

```Dockerfile
FROM python:3.8-slim

ENV FLASK_APP run.py
ENV APP_WORKDIR=/app
ENV APP_USER=zawzaw
ENV APP_PORT=8080

RUN python -m pip install --upgrade pip

RUN useradd --create-home ${APP_USER}

WORKDIR ${APP_WORKDIR}

COPY . .

RUN chown ${APP_USER}:${APP_USER} -R ${APP_WORKDIR}

RUN pip install -r requirements.txt

USER ${APP_USER}

EXPOSE ${APP_PORT}

ENTRYPOINT ["gunicorn", "--config", "gunicorn-cfg.py", "run:app"]
```

Dockerfile is very simple:
 - Install required Python packages with pip.
 - Serve Python Flask app with gunicorn server.

Build Docker container image locally:

```sh
$ docker build -t pod-info-app .
```

Run pod-info-app locally with Docker run:

```sh
$ docker run -p 8080:8080 -it --rm pod-info-app:latest
```

```sh
...
[2022-02-13 08:41:04 +0000] [1] [INFO] Starting gunicorn 20.0.4
[2022-02-13 08:41:04 +0000] [1] [DEBUG] Arbiter booted
[2022-02-13 08:41:04 +0000] [1] [INFO] Listening at: http://0.0.0.0:8080 (1)
[2022-02-13 08:41:04 +0000] [1] [INFO] Using worker: sync
[2022-02-13 08:41:04 +0000] [9] [INFO] Booting worker with pid: 9
[2022-02-13 08:41:04 +0000] [1] [DEBUG] 1 workers
```

Test application locally:

 - [http://0.0.0.0:8080](http://0.0.0.0:8080)

![Screenshot](/assets/images/screenshots/img_screenshot_pod_info_app.png)

Final step,
Build and Push Docker container image into your Docker Registry.

For example: My Docker Hub username is `zawzaww`. It depends on your Docker Hub user name.

```sh
$ docker build -t zawzaww/pod-info-app .
```

```sh
$ docker push zawzaww/pod-info-app:latest
```

```sh
The push refers to repository [docker.io/zawzaww/pod-info-app]
687ccfae7d0e: Pushed
779e7681e9a7: Pushed
f57ce0722888: Pushed
34decbbd20d2: Pushed
314e501bfdc5: Pushed
9c81064245d9: Pushed
87ea2744abf2: Mounted from library/python
51f094ff7b94: Mounted from library/python
1a40cb2669f8: Mounted from library/python
32034715e5d4: Mounted from library/python
7d0ebbe3f5d2: Mounted from library/python
latest: digest: sha256:2f584b970b2bb5d9db9ece9d36cf8426ad7b9c4fc0dc1e059c6d1c02805c2395 size: 2629
```

## Create and Write a Helm Chart
### Understanding application concepts

Before we write a Helm chart for our application,
we firstly need to understand how our application has designed, how our application works and so on.

This [pod-info](https://gitlab.com/gitops-argocd-demo/webapp) is a very simple web application written in Python with Flask.

In pod-info application, we will display the following information in Web UI:
 - Namespace
 - Node Name
 - Pod Name
 - Pop IP

For Example:

![Screenshot](/assets/images/screenshots/img_screenshot_pod_info_data.png){: .normal }

Basically, pod-info application gets information dynamically through the Kubernetes environment variables.
So, we need to expose pod information to container through the environment variables in Kubernetes.
Then, app uses this environment variables to get information dynamically.

Ref: [Expose Pod Information to Containers Through Environment Variables](https://kubernetes.io/docs/tasks/inject-data-application/environment-variable-expose-pod-information)

For example, we can set this `ENV` variables with key/value form in Kubernetes deployment like this:

```yaml
env:
  - name: NODE_NAME
    valueFrom:
      fieldRef:
        fieldPath: spec.nodeName
  - name: NAMESPACE
    valueFrom:
      fieldRef:
        fieldPath: metadata.namespace
  - name: POD_NAME
    valueFrom:
      fieldRef:
        fieldPath: metadata.name
  - name: POD_IP
    valueFrom:
      fieldRef:
        fieldPath: status.podIP
```

It's like key value form:
 - `NODE_NAME`=`spec.nodeName`
 - `NAMESPCE`=`metadata.namespace`
 - `POD_NAME`=`metadata.name`
 - `POD_IP`=`status.podIP`

### Initialize a Helm Chart with Helm CLI
Before you start, make sure you understand **Kubernete Objects** and **Workloads Resources** first.
If you are not fimiliar with Kubernetes, you can learn from [Kubernetes Basics](https://kubernetes.io/docs/tutorials/kubernetes-basics) tutorial.

After we understand pod-info-app's concept, let's create a Helm chart with Helm CLI tool.

Initialize a Helm chart:

```sh
$ helm create pod-info
Creating pod-info
```

Then, Helm automatically generates required Helm templates and values like this:

```sh
[zawzaw@redhat-linux:~/helm/helm-charts/pod-info]$ tree
.
├── Chart.yaml
├── templates
│   ├── deployment.yaml
│   ├── _helpers.tpl
│   ├── hpa.yaml
│   ├── ingress.yaml
│   ├── NOTES.txt
│   ├── serviceaccount.yaml
│   ├── service.yaml
│   └── tests
│       └── test-connection.yaml
└── values.yaml

2 directories, 10 files
```

### Writing and Customizing Helm Chart

Basically, Helm Charts have main three categories:

 - `Chart.yaml`
   - Define Helm chart name, description, chart revision and so on.

 - `templates/`
   - Helm templates are general and dynamic configurations that locate Kubernetes resources
   written in YAML-based [Helm template language](https://helm.sh/docs/chart_template_guide).
   It means that we can pass variables from `values.yaml` file into templates files when we deploy Helm chart.
   So, values can be changed dynamically based on you configured Helm templates at deployment time.

 - `values.yaml`
   - Declare variables to be passed into Helm templates. So, when we run `helm install` to deploy Helm charts,
   Helm sets this variables into Helm templates files based on you configured templates and values.

In the other words, Helm charts are pre-configured configurations and packages as one unit to deploy applications esaily on Kubernetes cluster.

After initialize a new Helm chart, we need to customize Helm templates and values as you need. It depends on your web application.
For pod-info Helm chart, we need to configure the following steps.

#### Set Docker container image

- In `values.yaml` file, define variables for Docker container image that we've built and pushed into Docker registry.

  ```yaml
  image:
    repository: zawzaww/pod-info-app
    pullPolicy: IfNotPresent
    tag: "latest"
  ```

- In `templates/deployment.yaml` file, we can set variables from values.yaml with `.Values.image.repository`, `.Values.image.pullPolicay` and `.Values.image.tag`.
It's YAML-based Helm template language syntax. You can learn on [The Chart Template Developer's Guide](https://helm.sh/docs/chart_template_guide).
  - Get Docker image repository: `.Values.image.repository`
  - Get Docker image pull policy: `.Values.image.pullPolicy`
  - Get Docker image tag: `.Values.image.tag`

So, when need to get variables form `values.yaml` file, we can use `.Values` in Helm templates like this:

{% raw %}
```yaml
containers:
  - name: {{ .Chart.Name }}
    image: "{{ .Values.image.repository }}:{{ .Values.image.tag | default .Chart.AppVersion }}"
    imagePullPolicy: {{ .Values.image.pullPolicy }}
```
{% endraw %}

#### Set Service Port and Target Port

- In `values.yaml` file, define variables for sevice type, port and targetPort.

  ```yaml
  service:
    type: NodePort
    port: 80
    targetPort: http
  ```

- In `templates/service.yaml` file, we can set service varibales from values.yaml file like this:
  - Get service type: `.Values.service.type`
  - Get service port: `.Values.service.port`
  - Get service target port: `.Values.service.targetPort`

{% raw %}
```yaml
spec:
  type: {{ .Values.service.type }}
  ports:
    - port: {{ .Values.service.port }}
      targetPort: {{ .Values.service.targetPort }}
      protocol: TCP
      name: http
```
{% endraw %}

#### Set Target Docker Container Port

- In `values.yaml` file, define variable for container port that exposes `8080` in our pod-info-app's Docker container.

```yaml
deployment:
  containerPort: 8080
```

- In `templates/deployment.yaml` file, set target Docker container port variable from values.yaml file:
  - Get target container port: `.Values.deployment.containerPort`

{% raw %}
```yaml
containers:
 - name: {{ .Chart.Name }}
   ports:
    - name: http
      containerPort: {{ .Values.deployment.containerPort }}
      protocol: TCP
```
{% endraw %}

#### Set Environment Varibales

- In `values.yaml` file, define environment variables that our pod-info application use to get information data in Web UI.

```yaml
deployment:
  env:
    - name: NODE_NAME
      valueFrom:
        fieldRef:
          fieldPath: spec.nodeName
    - name: NAMESPACE
      valueFrom:
        fieldRef:
          fieldPath: metadata.namespace
    - name: POD_NAME
      valueFrom:
        fieldRef:
          fieldPath: metadata.name
    - name: POD_IP
      valueFrom:
        fieldRef:
          fieldPath: status.podIP
```

- In `templates/deployment.yaml`, set environment variables dynamically from values.yaml file.
  - So, when you need to pass the array and whole config block into Helm templates, you can use `- with` and `- toYaml`.

{% raw %}
```yaml
containers:
  - name: {{ .Chart.Name }}
    {{- with .Values.deployment.env }}
     env:
       {{- toYaml . | nindent 12 }}
    {{- end }}
```
{% endraw %}

## Debugging the Helm Templates

After we write Helm chart for pod-info application,
we can debug and test Helm templates with `helm template` command. So, `helm template` CLI shows passed real values into templates.

Format:

```sh
helm template <chart_name> <dir_path> --values <values_file_path>
```

For Example:

```sh
helm template pod-info-dev pod-info --values pod-info/values.yaml
```

If you have syntax errors, Helm shows error messages.

This is automatically generated by Helm Template CLI based on you configured Helm templates and values.

```yaml
---
# Source: pod-info/templates/serviceaccount.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: pod-info-dev
  labels:
    helm.sh/chart: pod-info-0.1.0
    app.kubernetes.io/name: pod-info
    app.kubernetes.io/instance: pod-info-dev
    app.kubernetes.io/version: "1.16.0"
    app.kubernetes.io/managed-by: Helm
---
# Source: pod-info/templates/service.yaml
apiVersion: v1
kind: Service
metadata:
  name: pod-info-dev
  labels:
    helm.sh/chart: pod-info-0.1.0
    app.kubernetes.io/name: pod-info
    app.kubernetes.io/instance: pod-info-dev
    app.kubernetes.io/version: "1.16.0"
    app.kubernetes.io/managed-by: Helm
spec:
  type: NodePort
  ports:
    - port: 80
      targetPort: http
      protocol: TCP
      name: http
  selector:
    app.kubernetes.io/name: pod-info
    app.kubernetes.io/instance: pod-info-dev
---
# Source: pod-info/templates/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: pod-info-dev
  labels:
    helm.sh/chart: pod-info-0.1.0
    app.kubernetes.io/name: pod-info
    app.kubernetes.io/instance: pod-info-dev
    app.kubernetes.io/version: "1.16.0"
    app.kubernetes.io/managed-by: Helm
spec:
  replicas: 1
  selector:
    matchLabels:
      app.kubernetes.io/name: pod-info
      app.kubernetes.io/instance: pod-info-dev
  template:
    metadata:
      labels:
        app.kubernetes.io/name: pod-info
        app.kubernetes.io/instance: pod-info-dev
    spec:
      serviceAccountName: pod-info-dev
      securityContext:
        {}
      containers:
        - name: pod-info
          securityContext:
            {}
          image: "zawzaww/pod-info-app:latest"
          imagePullPolicy: IfNotPresent
          ports:
            - name: http
              containerPort: 8080
              protocol: TCP
          env:
            - name: NODE_NAME
              valueFrom:
                fieldRef:
                  fieldPath: spec.nodeName
            - name: NAMESPACE
              valueFrom:
                fieldRef:
                  fieldPath: metadata.namespace
            - name: POD_NAME
              valueFrom:
                fieldRef:
                  fieldPath: metadata.name
            - name: POD_IP
              valueFrom:
                fieldRef:
                  fieldPath: status.podIP
          livenessProbe:
            httpGet:
              path: /
              port: http
          readinessProbe:
            httpGet:
              path: /
              port: http
          resources:
            limits:
              cpu: 100m
              memory: 128Mi
            requests:
              cpu: 100m
              memory: 128Mi
---
# Source: pod-info/templates/tests/test-connection.yaml
apiVersion: v1
kind: Pod
metadata:
  name: "pod-info-dev-test-connection"
  labels:
    helm.sh/chart: pod-info-0.1.0
    app.kubernetes.io/name: pod-info
    app.kubernetes.io/instance: pod-info-dev
    app.kubernetes.io/version: "1.16.0"
    app.kubernetes.io/managed-by: Helm
  annotations:
    "helm.sh/hook": test
spec:
  containers:
    - name: wget
      image: busybox
      command: ['wget']
      args: ['pod-info-dev:80']
  restartPolicy: Never
```

## Deploy Helm Chart on Kubernetes Cluster

We can now deploy pod-info application with Helm chart on our minikube Kubernetes cluster.

Deploy pod-info application simply like this:

Format:

```sh
$ helm install <chart_name> <dir_path> \
 --values <values_file_path> \
 --create-namespace \
 --namespace <namespace>
```

For example:

```sh
$ helm install pod-info-dev pod-info \
 --values pod-info/values.yaml \
 --create-namespace \
 --namespace dev
```

```sh
NAME: pod-info-dev
LAST DEPLOYED: Mon Feb 14 01:44:09 2022
NAMESPACE: dev
STATUS: deployed
REVISION: 1
NOTES:
1. Get the application URL by running these commands:
  export NODE_PORT=$(kubectl get --namespace dev -o jsonpath="{.spec.ports[0].nodePort}" services pod-info-dev)
  export NODE_IP=$(kubectl get nodes --namespace dev -o jsonpath="{.items[0].status.addresses[0].address}")
  echo http://$NODE_IP:$NODE_PORT
```

We've setup `NodePort` service type in your pod-info Helm chart's service configuration. So, we can access our application via `Node Port` from outside of Kubernetes cluster. Remember this:

```yaml
# Source: pod-info/templates/service.yaml
apiVersion: v1
kind: Service
metadata:
  name: pod-info-dev
  labels:
    helm.sh/chart: pod-info-0.1.0
    app.kubernetes.io/name: pod-info
    app.kubernetes.io/instance: pod-info-dev
    app.kubernetes.io/version: "1.16.0"
    app.kubernetes.io/managed-by: Helm
spec:
  type: NodePort
  ports:
    - port: 80
      targetPort: http
      protocol: TCP
      name: http
  selector:
    app.kubernetes.io/name: pod-info
    app.kubernetes.io/instance: pod-info-dev
```

So, to get and access the pod-info application in your web browser, run the following commands:

```sh
$ export NODE_PORT=$(kubectl get --namespace dev -o jsonpath="{.spec.ports[0].nodePort}" services pod-info-dev)
$ export NODE_IP=$(kubectl get nodes --namespace dev -o jsonpath="{.items[0].status.addresses[0].address}")
$ echo http://$NODE_IP:$NODE_PORT
```

```sh
http://192.168.58.2:32431
```

You can also assign this Node IP address with specific host entry in `/etc/hosts` file.

```
192.168.58.2     pod-info-dev.local
```

Our application's URL:

[http://pod-info-dev.local:32431](http://pod-info-dev.local:32431)

![Screenshot](/assets/images/screenshots/img_screenshot_pod_info_demo.png)

Now, you can see `Namespace`, `Node Name`, `Pod Name` and `Pod IP` data in pod-info Web UI application.

Credit and Thank to [@poom.wettayakorn](https://medium.com/@poom.wettayakorn) for [pod-info](https://gitlab.com/gitops-argocd-demo/webapp) Python Flask application.

