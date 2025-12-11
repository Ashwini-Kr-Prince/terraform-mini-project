variable "region" {
  type    = string
  default = "ap-south-1"
}

variable "vpc_cidr"       { type = string }
variable "public_subnets" { type = list(string) }
variable "private_subnets" { type = list(string) }
variable "azs"            { type = list(string) }

