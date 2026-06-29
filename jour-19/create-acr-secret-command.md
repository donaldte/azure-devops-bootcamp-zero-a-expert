kubectl create secret docker-registry <secret-name> --namespace <namespace> --docker-server <registry-name>.azurecr.io --docker-username <acr-username> --docker-password <acr-password> -n argocd


kubectl create secret docker-registry acr-secret --namespace default --docker-server <registry-name>.azurecr.io --docker-username <acr-username> --docker-password <acr-password>


