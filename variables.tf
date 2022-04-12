variable "project_name" {
  type        = string
  description = "The prefix name of the project"

}

variable "region_name" {
  type        = string
  description = "The name of the region"
}

variable "vpc_cidr" {
  type        = string
  description = "The VPC CIDR"
}

variable "public_a_cidr" {
  type        = string
  description = "The Public subnet CIDR for AZ a"
}

variable "public_b_cidr" {
  type        = string
  description = "The Public subnet CIDR for AZ b"
}

variable "private_a_cidr" {
  type        = string
  description = "The Private subnet CIDR for AZ a"
}

variable "private_b_cidr" {
  type        = string
  description = "The Private subnet CIDR for AZ b"
}

variable "data_a_cidr" {
  type        = string
  description = "The Data subnet CIDR for AZ a"
}

variable "data_b_cidr" {
  type        = string
  description = "The Data subnet CIDR for AZ b"
}