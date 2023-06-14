/*
 * provider "aws"
 * Modify the access keys if necessary
 */

provider "aws" {
  region = "us-east-1"
  #access_key = ""
  #secret_key = ""
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

#Terraform
/*terraform {
  backend "s3" {
    #bucket = "XXXXXXXXXX"                <----- Enable this field if need you create a bucketS3 with tfstate
    key    = "Terraform.tfstate"
    region = "us-east-1"
  }
}*/