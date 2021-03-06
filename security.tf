resource "aws_security_group" "lb" {
  name = "sal-${var.env}-lb"
  vpc_id = aws_vpc.main.id

  ingress {
    protocol = "tcp"
    from_port = 443
    to_port = 443
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  ingress {
    protocol = "tcp"
    from_port = 80
    to_port = 80
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  ingress {
    protocol = "tcp"
    from_port = 22
    to_port = 22
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }


  egress {
    protocol = "-1"
    from_port = 0
    to_port = 0
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
}



resource "aws_security_group" "db_tasks" {
  name = "syntheia-${var.env}-ecs"
  description = "allow inbound access from the ALB only"
  vpc_id = aws_vpc.main.id

  ingress {
    protocol = "-1"
    from_port = 0
    to_port = 0
    security_groups = [
      aws_security_group.lb.id
    ]
  }

  egress {
    protocol = "-1"
    from_port = 0
    to_port = 0
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
}