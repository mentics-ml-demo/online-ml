# TODO: create user and group and keypair

resource "aws_iam_policy" "ec2_instance_connect_policy" {
  lifecycle { prevent_destroy = true }

  name        = "Ec2InstanceConnectAll"

  policy = jsonencode({
    Version: "2012-10-17",
    Statement: [
        {
            Effect: "Allow",
            Action: "ec2-instance-connect:*",
            Resource: "*"
        }
    ]
  })
}

resource "aws_default_vpc" "default" {
  lifecycle { prevent_destroy = true }
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_default_subnet" "default" {
  lifecycle { prevent_destroy = true }
  availability_zone = "us-west-2b"
  map_public_ip_on_launch = false

  tags = {
    Name = "Default subnet for us-west-2b"
  }
}

resource "aws_security_group" "allow_ssh" {
  name   = "AllowSSH"
  description = "AllowSSH"
  vpc_id = aws_default_vpc.default.id

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    self        = "false"
    to_port     = "0"
  }

  ingress {
    cidr_blocks      = ["0.0.0.0/0"]
    description      = "SSH access"
    from_port        = "22"
    ipv6_cidr_blocks = ["::/0"]
    protocol         = "tcp"
    self             = "false"
    to_port          = "22"
  }
}

resource "aws_ec2_instance_connect_endpoint" "ec2_access" {
  lifecycle { prevent_destroy = true }
  subnet_id = aws_default_subnet.default.id
  security_group_ids = [aws_security_group.allow_ssh.id]
}
