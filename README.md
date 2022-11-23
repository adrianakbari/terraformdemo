# Automate GIS deployment
The second part of automating GIS deployment. Focusing on infrastructure provisioning using Terraform

## Infrastructure Provisioning
For this demo a multi-tier architecture is deployed using Terraform.

## Application Provisioning
Refer to part 1 of the automatomating GIS deployment series. 

## Architecture
A multi-tier architecture with 3 tiers: A web tier, A GIS tier and a Database tier.
For installating the whole GIS Stack on a single VM use Esri provided azure image. Thats faster!

## Prerequisite
Nothing. Just install Terraform

## Installation
For installating Terraform and configuring it to work with Azure:
1. Download and move Terraform binary file to a folder in $PATH:
    mv ~/Downloads/terraform /usr/local/bin/
2. Verify Installation: 
    terraform -help
3. Install Azure CLI. Refer to Azure Documentation for the details.
4. Login to Azure using CLI
5. Create a service principal:
    az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/<SUBSCRIPTION_ID>"
6. Setup environment variables with the values returned from the last command:
    $ $Env:ARM_CLIENT_ID = "<APPID_VALUE>"
    $ $Env:ARM_CLIENT_SECRET = "<PASSWORD_VALUE>"
    $ $Env:ARM_SUBSCRIPTION_ID = "<SUBSCRIPTION_ID>"
    $ $Env:ARM_TENANT_ID = "<TENANT_VALUE>"
For more details refer to Terraform docs: https://developer.hashicorp.com/terraform/tutorials/azure-get-started/infrastructure-as-code


## Run Terraform
1. clone this directory
2. cd to the folder
3. Adjust parameters. For example vm sizes, names, load balancer and public ip properties, etc.
3. Run: terraform init
4. Run: terraform validate
5. Run: terraform fmt
6. Run: terraform apply


## Considerations
- this implementation is NOT secured. It suits the dev/test workloads. For production apply security best practices. 
- In this deployment server requirements are installed using cloud-init. for each server role a different cloud-init file is provided with specific requirements of that node. 
- infrastructure is designed to be cost effective. For a performance environment, adjust the parameters of vms, public ips, load balancer, etc. 
- For designing more complicated environments contact me. 

## Contact
I love to hear what you think about my work. For questions, feedback or just to have a brainstorm session!
Contact me on akbari.adrian@gmail.com