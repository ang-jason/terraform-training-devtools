data "aws_vpc" "default_vpc" {
  default = true
}

data "aws_subnets" "default_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default_vpc.id]
  }
}

# Retrives more information about each subnet
data "aws_subnet" "default_subnets_info" {
  for_each = toset(data.aws_subnets.default_subnets.ids)
  id       = each.key
}

data "aws_ami" "docker_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["*amazon-ecs-optimized*"]
  }
}

resource "aws_instance" "multi_az" {
  for_each      = data.aws_subnet.default_subnets_info
  instance_type = "t2.micro"
  ami           = "ami-0d058fe428540cd89"
  subnet_id     = each.key
  tags = {
    "Name" = "instance-${each.value.availability_zone}"
  }
}

output "instance_private_ips" {
  value = [for i in aws_instance.multi_az : i.private_ip]
}
