# This block configures Terraform itself, including which providers to install
# and which version of Terraform to use to provision out infrastructure.
# It is recommended to maintain this in a dedicated terraform.tf file
terraform {
  # required terraform version
  required_version = ">=1.14"

  # select the provider version
  # source contains address of the provider in the Terraform Registry.
  # here "hashicorp/aws" is shortened form of "registry.terraform.io/hashicorp/aws"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.22.1"
    }
  }
}

# set the provider
provider "aws" {
  # Configuration options here
  region = "us-east-2"
}
