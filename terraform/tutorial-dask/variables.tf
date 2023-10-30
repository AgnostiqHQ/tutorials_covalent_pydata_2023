variable "prefix" {
  default     = "covalent-dask-pydata2023"
  description = "Prefix to use for AWS resources"
}

variable "aws_region" {
  default     = "us-east-1"
  description = "Region in which Covalent is deployed"
}

variable "az_suffix" {
  default     = "a"
  description = "Availability zone suffix"
}

variable "scheduler_instance_type" {
  default     = "t3.small"
  description = "Instance type used for scheduler instance"
}

variable "worker_instance_type" {
  default     = "t3.xlarge"
  description = "Instance type used for the worker instance(s)"
}

variable "worker_instance_type_gpu" {
  default     = "g4dn.xlarge"
  description = "Instance type used for the worker instance(s) with GPU"
}

variable "enable_gpu" {
  type        = bool
  default     = false
  description = "Enable GPU support"
}

variable "n_workers" {
  default     = 1
  description = "Number of dask workers (i.e. EC2 instances)"
}

variable "scheduler_port" {
  type        = number
  default     = 8786
  description = "Dask scheduler port"
}

variable "dashboard_port" {
  type        = number
  default     = 8787
  description = "Dask dashboard port"
}

variable "covalent_package_version" {
  default     = "0.220.0.post2"
  description = "Covalent package version"
}

variable "python_version" {
  default     = "3.8.18"
  description = "Python version"
}

variable "miniconda_exe" {
  default     = "Miniconda3-latest-Linux-x86_64.sh"
  description = "Miniconda executable"
}
