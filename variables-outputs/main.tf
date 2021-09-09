variable "name" {
  type    = string
  default = "awesome-app"
}

locals {
  ami_id        = "ami-0f511ead81ccde020"
  instance_type = "t2.micro"
}


resource "aws_instance" "app_server" {
  ami           = local.ami_id
  instance_type = local.instance_type

  tags = {
    Name = var.name
  }
}

resource "aws_instance" "db_server" {
  ami           = local.ami_id
  instance_type = local.instance_type

  tags = {
    Name = "${var.name}-db"
  }
}

output "instance_ips" {
  value = [aws_instance.app_server.public_ip, aws_instance.db_server.public_ip]
}

output "instance_ids" {
  value = [aws_instance.app_server.id, aws_instance.db_server.id]
}
