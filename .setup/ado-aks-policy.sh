# Create a resource group
az group create --name ado-aks-policy-rg --location eastus

# Create a container registry
az acr create --resource-group ado-aks-policy-rg --name adoakscr --sku Basic

# Create a Kubernetes cluster
az aks create --resource-group ado-aks-policy-rg --name ado-aks-policy --node-count 1 --enable-addons monitoring --generate-ssh-keys

# Provider register: Register the Azure Policy provider
az provider register --namespace Microsoft.PolicyInsights

# Log in first with az login if you're not using Cloud Shell
az aks enable-addons --addons azure-policy --name ado-aks-policy --resource-group ado-aks-policy-rg

# Verify that the latest add-on is installed
az aks show --query addonProfiles.azurepolicy -g ado-aks-policy-rg -n ado-aks-policy

# Get the credentials for the Kubernetes cluster
az aks get-credentials --resource-group ado-aks-policy-rg --name ado-aks-policy

# azure-policy pod is installed in kube-system namespace
kubectl get pods -n kube-system

# gatekeeper pod is installed in gatekeeper-system namespace
kubectl get pods -n gatekeeper-system

# On Demand complience scan
az policy state trigger-scan --resource-group "ado-aks-policy-rg"