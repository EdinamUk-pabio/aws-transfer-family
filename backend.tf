# terraform {
#   backend "s3" {
#     bucket               = "CloudOps-infra-state"      #Name of the bucket
#     key                  = "terraform.tfstate"         #'path/to/key' state is written to the this key location
#     region               = "us-east-1"                 #Name of the region where your s3 bucket is located
#     workspace_key_prefix = "2-tier-app"                #Prefix applied to the state path inside bucket,This is only valid for non default workspaces.
#     dynamodb_table       = "cloud-infra-tf-state-lock" #Name of the dynamodb table.
#     encrypt              = true                        #A boolean value to enable/disable server side encryption.
#   }
# }
