resource "aws_instance" "sal_ec2_instance" {
  count = var.instances
  ami                         = var.image
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public[0].id
  vpc_security_group_ids      = [aws_security_group.lb.id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.sal_pair_key.key_name
  
  
  tags = {
    Name = "sal_ec2_instance${count.index}"
  }
}
