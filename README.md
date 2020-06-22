##This Script creates an AWS Internet-facing Application Load Balancer in 2 availability zones##

<b>Pre-Requisites to run this script :</b>
1. Terraform must be installed and properly setup in path environment variable
2. The repository is cloned or downloaded. Use the following command on terminal/cmd to clone it.
git clone https://github.com/AnkitCloudDev/AWSALBProvisioningScripts-TF-FL.git
3. Get the access and secret key of your AWS account and enter them in the <b>"provider.tf"</b> file. 

<b>NOTE<b>: If you have awscli configured then only mention the region and remove the keys from provider as terraform will automatically pick them up from awscli config.

<B>How to Download and run</B> : 

1. Use the console to navigate to the downloaded folder

2. Run terraform init to initialize

3. Run terraform plan to see what changes will be there upon execution

4. Run terraform apply to apply the changes 

5. Use terraform destroy to destroy the resources after you are done

