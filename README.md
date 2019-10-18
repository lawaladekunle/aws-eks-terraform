AWS EKS TERRAFORM SCRIPTS
=================================
These scripts allows you to run a production EKS cluster inside AWS. You will need to run "terraform init" to add the AWS provider package.

Run "terraform plan" you will be prompted to select a region eg: us-east-1. Terraform will create the plan and afterwards you can run "terraform apply".

In order to add nodes to the EKS cluster you will need to use "terraform output config_map_aws_auth > config_map_aws_auth.yaml" to create a yaml file for the config map that allows the worker nodes to use IAM role for authentication.

Run "kubectl apply -f config_map_aws_auth.yaml" to create the config map. Use kubectl get nodes --watch to see the nodes joining the cluster.

   

