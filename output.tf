output "instance_public_ip_addresses" {
  value = {
    for instance in aws_instance.sal_ec2_instance:
    instance.id => instance.public_ip
  }
}

output "db_access_endpoint" {  
  value  = aws_db_instance.main.endpoint  
}
