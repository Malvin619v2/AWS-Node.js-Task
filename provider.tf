# provider.tf

# Specify the provider and access details to access Amaxon AWS
provider "aws" {
  shared_credentials_file = "$HOME/.aws/credentials"
  profile                 = "default"
  region                  = var.aws_region
}
