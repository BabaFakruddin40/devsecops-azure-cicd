az group create --name "tfstate-devsecops-rg" --location "eastus"
az group create --name "devsecops-rg" --location "eastus"

#create storage account for terraform state
az storage account create --name "tfstateaccount28032026" --resource-group "tfstate-devsecops-rg" --location "eastus" --sku Standard_LRS
az storage container create --name "tfstate" --account-name "tfstateaccount28032026"

#create service principal for terraform,if alread exists use the existing one
SP_NAME="my-automation-sp"
SP=$(az ad sp list --display-name $SP_NAME --query "[0].appId" -o tsv)
if [ -z "$SP" ]; then
  SP=$(az ad sp create-for-rbac --name $SP_NAME --role="Contributor" --scopes="/subscriptions/$(az account show --query id -o tsv)/resourceGroups/devsecops-rg" --query appId -o tsv)
  echo "Service principal created with appId: $SP"
else
  echo "Service principal already exists with appId: $SP"
fi

#check the roles assigned to the service principal, if we are using an existing one, it should have the contributor role assigned to the devsecops-rg resource group    
az role assignment list --assignee $SP_NAME --query "[].{role:roleDefinitionName, scope:scope}" -o table



