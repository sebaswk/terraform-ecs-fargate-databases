#General
variable "project_name" {
  default = "XXXXXXXXXX"
}

variable "vpc-id" {
  default = "XXXXXXXXXX"
}

variable "subnet_public" { #Subnet Id
  type = list(string)
  default = ["XXXXXXXXXX", "XXXXXXXXXX", "XXXXXXXXXX"]
}

variable "subnet_private" { #Subnet Id
  type = list(string)
  default = ["XXXXXXXXXX", "XXXXXXXXXX", "XXXXXXXXXX"]
}

variable "subnet_isolated" { #Subnet Id
  type = map(string)
  default = {
    subnet_1a = "XXXXXXXXXX"
    subnet_1b = "XXXXXXXXXX"
    subnet_1c = "XXXXXXXXXX"
  }
}

#Subnets in security groups
variable "subnet_private_cidr" { #Subnet CIDRs
  type = list(string)
  default = ["XXXXXXXXXX/XX", "XXXXXXXXXX/XX", "XXXXXXXXXX/XX"]
}

variable "subnet_isolated_cidr" { #Subnet CIDRs
  type = list(string)
  default = ["XXXXXXXXXX/XX", "XXXXXXXXXX/XX", "XXXXXXXXXX/XX"]
}

variable "keypair" {
  default = "" #<---- Your need a keypair already create
}

############################################################################

#Bastion
variable "ami_id_bastion" {
  default     = "ami-0715c1897453cabd1" #Amazon linux 2023
  description = "Bastion ami"
}

variable "instance_type" {
  default     = "t3a.micro"
  description = "Instance type bastion"
}

variable "desired_capacity_min_max" {
  default     = "1"
  description = "Bastion desired capacity (min - max)"
}

############################################################################

#Alb_Ecs
variable "docker_port" {
  default     = "80"
  description = "Alb listener"
}

variable "target_group_port" {
  default     = "80"
  description = "Target port to instance"
}

#Ecs
variable "ami_id_ecs_cluster" {
  default     = "ami-0715c1897453cabd1" #Amazon linux 2023
  description = "EcsCluster ami"
}

variable "instance_type_ecs" {
  default     = "t3a.medium"
  description = "Instance type ecs"
}

#Container
variable "task_cpu" {
  default     = "1024"
  description = "Cpu used by task definition"
}

variable "task_memory" {
  default     = "3072"
  description = "Memory used by task definition"
}

#By default the port mapping has ports 80 configured

variable "app_image" {
  default = "XXXXXXXXXX"
  description = "Image from ECR"
}

variable "app_logs" {
  default = "XXXXXXXXXX" #<--- The full name must be in lowercase
  description = "Name for cloudwatch logs"
}

variable "app_count" {
  default     = "1"
  description = "Number of docker containers to run"
}

############################################################################

#Ec2DatabaseSql
variable "instance_type_ec2db" {
  default     = "t3a.medium"
  description = "Instance type Ec2DatabaseSQL"
}

variable "count_databases" {
  default = "3"
}

variable "disk_size" {
  default = 500
}

############################################################################
