data "aws_vpc" "default_vpc" {
  default = true
}

data "aws_subnets" "default_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default_vpc.id]
  }
}

module "ec2_cluster" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 2.21.0"

  name           = "app-cluster"
  instance_count = 4

  ami           = "ami-0f511ead81ccde020"
  instance_type = "t2.micro"
  subnet_ids    = data.aws_subnets.default_subnets.ids

  tags = {
    Terraform   = "true"
    Environment = "production"
  }
}
