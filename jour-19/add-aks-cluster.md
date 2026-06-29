az aks get-credentials \
  --resource-group <RESOURCE_GROUP> \
  --name <CLUSTER_NAME> --overwrite-existing


If kubectl is not installed

Install it with:

az aks install-cli

Then verify:

kubectl version --client