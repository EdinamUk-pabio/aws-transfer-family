### AWS Transfer Family (SFTP) Terraform Module Custom IDP.

#### Resources Created by the module.
* S3 Bucket
* Lambda function
* Users Roles
* Secrets 
* transfer family server


#### How To Run The Project

```bash

#Initialize project
terraform init

#Validate 
terraform validate

#Plan 
terraform plan -var-file configs/dev.tfvars

#Apply
terraform apply -var-file configs/dev.tfvars

```

