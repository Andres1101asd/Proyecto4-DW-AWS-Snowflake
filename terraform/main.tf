
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# Creamos el Bucket S3 para la capa Bronze
resource "aws_s3_bucket" "data_lake_bronze" {
  bucket = "proyecto4-dw-bronze-andres1101asd" # El nombre debe ser único en TODO AWS
  
  tags = {
    Name        = "Bronze Layer"
    Environment = "Academic"
  }
}