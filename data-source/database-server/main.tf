data "aws_vpc" "default_vpc" {
  default = true
}

data "terraform_remote_state" "app_servers_state" {
  backend = "s3"
  config = {
    region = "ap-southeast-1"
    bucket = "terraform-state-bucket-stanley"
    key    = "data-source/multi-az.tfstate"
  }
}

locals {
  private_ips_in_cidr_form = [for ip in data.terraform_remote_state.app_servers_state.outputs.instance_private_ips : "${ip}/32"]
}

output "private_ips_in_cidr_form" {
  value = local.private_ips_in_cidr_form
}

resource "aws_security_group" "db_firewall" {
  name        = "db-firewall"
  description = "Rules for DB server"
  vpc_id      = data.aws_vpc.default_vpc.id
}

resource "aws_security_group_rule" "allow_app_servers" {
  type              = "ingress"
  from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"
  cidr_blocks       = local.private_ips_in_cidr_form
  security_group_id = aws_security_group.db_firewall.id
}

resource "aws_instance" "db_server" {
  instance_type = "t2.micro"
  ami           = "ami-0d058fe428540cd89"

  vpc_security_group_ids = [aws_security_group.db_firewall.id]
  tags = {
    Name = "restricted-db-server"
  }
}

