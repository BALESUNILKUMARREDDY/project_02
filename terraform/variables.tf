variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "ec2_ami" {
  description = "AMI ID for EC2 instance"
  type        = string
  default     = "ami-0c02fb55956c7d316" # Update with your preferred AMI
}

variable "ec2_instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "s3_bucket_name" {
  description = "S3 bucket name for artifacts (must be globally unique)"
  type        = string
  default     = "flask-ml-artifacts-1234567890"  # Change this to unique bucket name
}

variable "kubeconfig_path" {
  description = "Path to Kubernetes kubeconfig"
  type        = string
  default     = "~/.kube/config"
}

variable "k8s_namespace" {
  description = "Kubernetes namespace for the app"
  type        = string
  default     = "flask-ml-namespace"
}

variable "docker_image" {
  description = "Docker image with tag to deploy on Kubernetes"
  type        = string
  default     = "my-docker-username/my-flask-ml-app:latest"
}