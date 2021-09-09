module "multi_az_cluster" {
  source = "../modules/ec2-cluster"

  name          = "app"
  num_instances = 4

  tags = {
    Enviroment = "production"
    Terraform  = true
  }
}

output "app_server_ips" {
  value = module.multi_az_cluster.public_ips
}

output "app_server_public_dns_names" {
  value = module.multi_az_cluster.public_dns
}

module "multi_az_db_cluster" {
  source = "../modules/ec2-cluster"

  name          = "db"
  num_instances = 2
  instance_type = "t3a.nano"

  tags = {
    Enviroment = "production"
    Terraform  = true
  }
}
