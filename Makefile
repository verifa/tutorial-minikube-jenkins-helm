HELM_RELEASE=jenkins
KUBECTL_NAMESPACE=jenkins

.PHONY: deploy

create-namespace:
	kubectl apply -f jenkins/jenkins-namespace.yaml

create-jcasc-configmap:
	kubectl create configmap jenkins-casc-config --from-file jenkins/jenkins-casc-config.yaml --dry-run -o yaml > jenkins/jenkins-casc-config-configmap.yaml
	kubectl apply -f jenkins/jenkins-casc-config-configmap.yaml --namespace $(KUBECTL_NAMESPACE)

install-jenkins: create-namespace create-jcasc-configmap
	helm install --name $(HELM_RELEASE) -f jenkins/jenkins-values.yaml stable/jenkins --namespace $(KUBECTL_NAMESPACE) --version v1.1.20

delete-jenkins:
	helm delete --purge $(HELM_RELEASE)