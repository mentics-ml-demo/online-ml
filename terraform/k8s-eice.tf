resource "aws_ec2_instance_connect_endpoint" "mentics_demo_eice" {
    subnet_id = aws_subnet.us-west-2b-mentics-demo-k8s-local.id
    preserve_client_ip = false
    security_group_ids = [aws_security_group.k8s-eice.id]
    tags = {
        Name = "Kubernetes eice"
    }
}

resource "aws_security_group" "k8s-eice" {
  name   = "k8s-allow-ssh"
  description = "Allow ssh for k8s access"
  vpc_id = aws_vpc.mentics-demo-k8s-local.id

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
