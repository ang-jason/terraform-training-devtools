variable "create_instance" {
  type    = bool
  default = false
}

locals {
  ami_id        = "ami-0f511ead81ccde020"
  instance_type = "t2.micro"
}

resource "aws_instance" "instance" {
  count         = var.create_instance ? 1 : 0
  ami           = local.ami_id
  instance_type = local.instance_type

  tags = {
    Name = "Server conditionally created"
  }
}

resource "aws_instance" "many_instances" {
  count         = 2
  ami           = local.ami_id
  instance_type = local.instance_type

  tags = {
    Name = "server ${count.index}"
  }
}

locals {
  users = ["bob", "alice"]
}

resource "aws_iam_user" "users" {
  for_each = toset(local.users)
  name     = each.key
}

locals {
  instances = {
    app = {
      instance_type = local.instance_type
      ami_id        = local.ami_id
    },
    db = {
      instance_type = "t3a.micro"
      ami_id        = "ami-0d058fe428540cd89"
    }
  }
}

resource "aws_instance" "instances" {
  for_each      = local.instances
  ami           = each.value.ami_id
  instance_type = each.value.instance_type

  tags = {
    Name = "${each.key}-server"
  }
}

output "instance_ids" {
  value = [for i in aws_instance.instances : i.id]
}

output "instance_id_name_map" {
  value = { for i in aws_instance.instances : i.id => i.tags.Name }
}

output "instance_ids_splat" {
  value = aws_instance.many_instances[*].id
}

locals {
  volumes = [
    {
      device_name = "/dev/sdc"
      volume_size = "8"
    },
    {
      device_name = "/dev/sdf"
      volume_size = "10"
    }
  ]
}

resource "aws_instance" "instance_with_many_volumes" {
  ami           = local.ami_id
  instance_type = local.instance_type

  tags = {
    Name = "Multi volume instance"
  }

  dynamic "ebs_block_device" {
    for_each = { for v in local.volumes : v.device_name => v }
    iterator = volume
    content {
      device_name = volume.value.device_name
      volume_size = volume.value.volume_size
      volume_type = "gp2"
    }
  }
}

