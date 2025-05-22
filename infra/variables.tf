variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "min_vcpus" {
  description = "Minimum vCPUs for the compute environment"
  type        = number
  default     = 0
}

variable "max_vcpus" {
  description = "Maximum vCPUs for the compute environment"
  type        = number
  default     = 16
}

variable "desired_vcpus" {
  description = "Desired vCPUs for the compute environment"
  type        = number
  default     = 0
}

variable "docker_image" {
  description = "Docker image for the job definition"
  type        = string
}

variable "instance_type" {
  description = "Instance type for the compute environment"
  type        = list(string)
  default     = ["g5.xlarge"]  # GPU instance
}

variable "s3_bucket" {
  description = "S3 bucket for job input/output"
  type        = string
}

variable "preprocessed_images_dir_prefix" {
  description = "S3 folder where images are stored. Environment variable."
  type        = string
}

variable "s3_processed_dataset_prefix" {
  description = "S3 folder where extracted data is stored. Environment variable."
  type        = string
}

variable "ecr_repository_name" {
  description = "Name of the ECR repository"
  type        = string
  default     = "demo-invoice-structured-outputs"
}
