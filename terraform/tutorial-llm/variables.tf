variable "prefix" {
  default     = "covalent-pydata2023"
  description = "Prefix used for the AWS Resources created for the executor"
}
variable "aws_region" {
  default     = "us-east-1"
  description = "Region in which Covalent is deployed"
}

variable "az_suffix" {
  default     = "a"
  description = "Availability zone suffix"
}

variable "instance_types" {
  type        = list(any)
  description = "Instance type used for Covalent"
  default = ["c4.xlarge", "g4dn.xlarge"]
}

variable "min_vcpus" {
  type        = number
  description = "Minimum number of vCPUs to use for Covalent"
  default     = 0
}

variable "max_vcpus" {
  type        = number
  description = "Maximum number of vCPUs to use for Covalent"
  default     = 256
}

variable "aws_s3_bucket" {
  # Generate unique suffix for S3 bucket.
  default     = ""
  description = "S3 bucket used for file batch job resources"
}
variable "aws_batch_queue" {
  default     = "queue"
  description = "Batch queue used for jobs"
}

variable "aws_batch_job_definition" {
  default     = "job-definition"
  description = "Batch queue used for jobs"
}

variable "vpc_cidr" {
  default     = "10.0.0.0/24"
  description = "VPC CIDR range"
}
