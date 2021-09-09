output "private_ips" {
  value = [for i in aws_instance.cluster : i.private_ip]
}

output "public_ips" {
  value = [for i in aws_instance.cluster : i.public_ip]
}

output "instance_ids" {
  value = [for i in aws_instance.cluster : i.id]
}

output "public_dns" {
  value = [for i in aws_instance.cluster : i.public_dns]
}
