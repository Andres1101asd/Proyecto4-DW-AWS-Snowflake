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

# --- CAPA BRONZE (El bucket original) ---
resource "aws_s3_bucket" "data_lake_bronze" {
  bucket = "proyecto4-dw-bronze-andres1101asd"
}

# --- AIRFLOW (MWAA) ---
# 1. Bucket S3 para guardar los DAGs de Airflow
resource "aws_s3_bucket" "airflow_bucket" {
  bucket = "proyecto4-mwaa-airflow-andres1101asd"
}

resource "aws_s3_bucket_versioning" "airflow_bucket_versioning" {
  bucket = aws_s3_bucket.airflow_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# 2. Rol de IAM para que MWAA pueda ejecutar cosas
resource "aws_iam_role" "mwaa_role" {
  name = "mwaa-execution-role-proyecto4"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "airflow.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "mwaa_policy" {
  role       = aws_iam_role.mwaa_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# 3. Crear el entorno de Airflow (MWAA)
resource "aws_mwaa_environment" "airflow_env" {
  name                = "proyecto4-airflow"
  airflow_version     = "2.8.1"
  environment_class   = "mw1.small"
  execution_role_arn  = aws_iam_role.mwaa_role.arn
  source_bucket_arn   = aws_s3_bucket.airflow_bucket.arn

  dag_s3_path         = "dags/"
  requirements_s3_path = "requirements.txt"

  network_configuration {
    security_group_ids = [aws_security_group.mwaa_sg.id]
    subnet_ids         = [aws_subnet.mwaa_subnet.id, aws_subnet.mwaa_subnet_2.id]
  }

  logging_configuration {
    dag_processing_logs {
      enabled   = true
      log_level = "INFO"
    }
    task_logs {
      enabled   = true
      log_level = "INFO"
    }
  }
}

# 4. Red (VPC, Subnet, Security Group) - Requerido por MWAA
resource "aws_vpc" "mwaa_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = { Name = "mwaa-vpc" }
}

resource "aws_subnet" "mwaa_subnet" {
  vpc_id            = aws_vpc.mwaa_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = { Name = "mwaa-subnet-1" }
}

# NUEVA SUBRED 2 (Requerida por MWAA)
resource "aws_subnet" "mwaa_subnet_2" {
  vpc_id            = aws_vpc.mwaa_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b" # Zona de disponibilidad diferente
  tags = { Name = "mwaa-subnet-2" }
}

resource "aws_security_group" "mwaa_sg" {
  name        = "mwaa-security-group"
  vpc_id      = aws_vpc.mwaa_vpc.id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}