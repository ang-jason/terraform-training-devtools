locals {
  range_list = range(var.num_instances)
  num_azs    = length(data.aws_availability_zones.available.names)
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_instance" "cluster" {
  for_each = { for i in local.range_list : "${var.name}-${i}" => i }

  instance_type = var.instance_type
  ami           = var.ami_id

  # Automatically distribute each instance to a different availability zone
  availability_zone = data.aws_availability_zones.available.names[each.value % local.num_azs]

  tags = merge(var.tags, {
    Name = each.key
  })
}
