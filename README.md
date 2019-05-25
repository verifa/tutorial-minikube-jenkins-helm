# Introduction

This tutorial was created for internal training, coaching and also to get a feel for the work we are doing at Verifa.

The basic idea is to use [Minikube](https://kubernetes.io/docs/setup/minikube/) to setup a local Kubernetes cluster and then use Helm to deploy a Jenkins instance with a slave using the Jenkins [Helm Chart](https://github.com/helm/charts/tree/master/stable/jenkins)

The task is then to create a Jenkins pipeline using [Delcarative Jenkins Pipelines](https://jenkins.io/doc/book/pipeline/syntax/#declarative-pipeline) and add automated steps like build and test using Docker-based environments.

It is not necessary to have prior knowledge in Kubernetes or Helm charts as we have made that easy for you :) However, knowledge in Jenkins, pipelines and basic Docker knowledge is required and can also be learnt as part of this process.

# Getting Started

## Prerequisites

The prerequisites for this project are to have [Docker](https://docs.docker.com/install/), [Kubernetes (kubectl command line)](https://kubernetes.io/docs/tasks/tools/install-kubectl/), [Kubeneretes Helm](https://helm.sh/docs/using_helm/) and [Minikube](https://kubernetes.io/docs/setup/minikube/) installed, with a preferred Virtual Machine provider such as [VirtualBox](https://www.virtualbox.org/wiki/Downloads)

Part of the test begins here with installing tools and configuring your environment :)

## Create Minikube Kubernetes Cluster

This tutorial assumes you are using VirtualBox as a VM provider. Open your favourite command prompt and follow these steps:

1. Run the Minikube Start Command to create your cluster

```
minikube start — vm-driver=virtualbox
```

2. Check the status of your Minikube instance

```
minikube status
```

3. Check the Minikube Dashboard

The minikube dashboard is your friend for checking the status of your Kubernetes cluster. Run the below command and follow the URL it provides

```
minikube dashboard
```

## Deploy Jenkins to your Minikube Kubernetes Cluster

Jenkins is deployed using the [Helm Chart](https://github.com/helm/charts/tree/master/stable/jenkins) and is configured using [Jenkins Configuration as Code (JCasC)](https://github.com/jenkinsci/configuration-as-code-plugin)

All the configuration files are under the jenkins/ folder.

1. Create your Jenkins Kuberentes Namespace

The Jenkins namespace is defined in the jenkins/jenkins-namespace.yaml file

```
kubectl apply -f jenkins/jenkins-namespace.yaml
```

2. Create and Deploy the JCasC Config Map

The configuration for JCasC is defined in the YAML file jenkins/jenkins-casc-config.yaml. Everytime you modify this file, the below command should be re-run

```
kubectl create configmap jenkins-casc-config --from-file jenkins/jenkins-casc-config.yaml --dry-run -o yaml > jenkins/jenkins-casc-config-configmap.yaml
kubectl apply -f jenkins/jenkins-casc-config-configmap.yaml --namespace jenkins
```

3. Install the Jenkins Helm Chart

Now we are going to use the Helm command to install the Jenkins chart.

To install Tiller on the cluster you need to initially run (once)

```helm init```

Then you can execute

```
helm install --name jenkins -f jenkins/jenkins-values.yaml stable/jenkins --namespace jenkins
```

Note that you can specify the exact version of the Helm chart to use by providing a ```--version vx.y.z``` argument. At the time of writing, we used ```--version v1.1.20```

If you have already used Helm to install Jenkins before, a ```helm repo update``` might be necessary to fetch new versions of the stable/jenkins chart.

4. Check that Jenkins is up and running

You may want to check your Minikube Dashboard, or use the kubectl command line like a pro to see that everything worked as expected. You can also visit your Jenkins instance at:

[http://192.168.99.100:32000/login](http://192.168.99.100:32000/login)

Login with username/password admin/admin... Security is not something we are worried about in this tutorial as the cluster is running locally on your machine.

You should now have a Jenkins instance ready to play with... so here begins the real exercise :)

# Troubleshooting

## Jenkins agents failing to start

We have experienced some resource issues (memory) with the default kubernetes cluster set up by minikube. The solution has been to allocate more memory to the cluster, by running:

```
minikube stop
minikube delete
minikube config set memory 8192 # to assign 8G of memory
```

## Pod retention for debugging

Current pod retention policy is to remove them if they fail, which means debugging is a little tricky. It can help significantly by setting the pod retention policy to "OnFailure"

# Exercise

Just like in the world of CI/CD/DevOps there is no _right_ or _correct_ way to do things, but following best practices is a good idea. Google is a good friend for this, so Google-Foo is a good martial art to know.

## 1. Visual Code Pipeline

[Visual Code](https://github.com/microsoft/vscode) is a good project to start with. The first task is to setup a Jenkins pipeline for Visual Code.

Rough tasks for this is to:
1. Fork the Visual Code Project
2. Create a Jenkinsfile in the project root directory
3. Define the Jenkinsfile using [Declarative Syntax](https://jenkins.io/doc/book/pipeline/syntax/#declarative-pipeline)
4. Configure a Pipeline project in your Jenkins instance to point to your forked Visual Code Repository
5. Run the pipeline...

You can find a basic example here [https://github.com/verifa/vscode](https://github.com/verifa/vscode) and the [Jenkinsfile](https://github.com/verifa/vscode/blob/master/Jenkinsfile)

## Will add more stuff sometime...

Other things that could be useful is adding tests to the pipeline, running static code analysis over the pipeline (SonarQube, FBInfer, tslint, etc)... Be creative!



