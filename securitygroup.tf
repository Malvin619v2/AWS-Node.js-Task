# AWS security groups (SGs) are associated with EC2 instances and provide security
# at the protocol and port access level. Each security group — working much the
# same way as a firewall — contains a set of rules that filter traffic coming
# into and out of an EC2 instance

resource "aws_security_group" "ecs-securitygroup" {
  vpc_id = "${aws_vpc.main.id}"
  name = "ecs"
  description = "security group for ecs"
  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
      from_port = 3000
      to_port = 3000
      protocol = "tcp"
      security_groups = ["${aws_security_group.myapp-elb-securitygroup.id}"]
  }
  ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "ecs"
  }
}
resource "aws_security_group" "myapp-elb-securitygroup" {
  vpc_id = "${aws_vpc.main.id}"
  name = "myapp-elb"
  description = "security group for ecs"
  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "myapp-elb"
  }
}
