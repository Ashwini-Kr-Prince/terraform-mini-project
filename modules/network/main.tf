variable "vpc_cidr" {}
variable "public_subnets" { type = list(string) }
variable "private_subnets" { type = list(string) }
variable "azs" { type = list(string) }
variable "tags" { type = map(string) }

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = merge(var.tags, { Name = "${var.tags["env"]}-vpc" })
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags   = merge(var.tags, { Name = "${var.tags["env"]}-igw" })
}

resource "aws_subnet" "public" {
  for_each = toset(var.public_subnets)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value
  map_public_ip_on_launch = true
  availability_zone       = element(var.azs, index(var.public_subnets, each.value))
  tags = merge(var.tags, {
    Name = "${var.tags["env"]}-public-${index(var.public_subnets, each.value)}"
    Tier = "public"
  })
}

resource "aws_subnet" "private" {
  for_each = toset(var.private_subnets)
  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value
  availability_zone = element(var.azs, index(var.private_subnets, each.value))
  tags = merge(var.tags, {
    Name = "${var.tags["env"]}-private-${index(var.private_subnets, each.value)}"
    Tier = "private"
  })
}

output "vpc_id" {
  value = aws_vpc.this.id
}

