variable "ssh_access_block" {
    type = string
    description = "CIDR block to allow ssh access to the load balancer"
}

output "haproxy_instance_id" {
  value = "aws_instance.haproxy.id"
}

resource "aws_instance" "load_balancer" {
    ami = "ami-01a43c6864f47cef1"
    instance_type = "t4g.small"
    availability_zone = "us-west-2b"
    key_name = "aws ec2"

    associate_public_ip_address = true
    credit_specification {
        cpu_credits = "standard"
    }

    root_block_device {
        delete_on_termination = true
        encrypted             = false
        iops                  = 3000
        throughput            = 125
        volume_size           = 8
        volume_type           = "gp3"
    }

    vpc_security_group_ids = [aws_security_group.load_balancer.id]
    subnet_id = aws_subnet.utility-us-west-2b-mentics-demo-k8s-local.id

    user_data = <<-EOL
#!/bin/bash
apt update
apt install haproxy
    EOL

    tags = {
        Name = "HAProxy"
    }
}

resource "aws_security_group" "load_balancer" {
  description = "Security group for load balancer"

  egress {
    cidr_blocks      = ["0.0.0.0/0"]
    from_port        = "0"
    ipv6_cidr_blocks = ["::/0"]
    protocol         = "-1"
    self             = "false"
    to_port          = "0"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "3"
    protocol    = "icmp"
    self        = "false"
    to_port     = "4"
  }

  ingress {
    cidr_blocks      = ["0.0.0.0/0"]
    from_port        = "443"
    ipv6_cidr_blocks = ["::/0"]
    protocol         = "tcp"
    self             = "false"
    to_port          = "443"
  }

  ingress {
    cidr_blocks      = ["0.0.0.0/0"]
    from_port        = "80"
    ipv6_cidr_blocks = ["::/0"]
    protocol         = "tcp"
    self             = "false"
    to_port          = "80"
  }

  ingress {
    cidr_blocks = [var.ssh_access_block]
    from_port   = "22"
    protocol    = "tcp"
    self        = "false"
    to_port     = "22"
  }

  ingress {
    from_port        = "-1"
    ipv6_cidr_blocks = ["::/0"]
    protocol         = "icmpv6"
    self             = "false"
    to_port          = "-1"
  }

  name = "lb.mentics-demo.k8s.local"

  tags = {
    KubernetesCluster                              = "mentics-demo.k8s.local"
    Name                                           = "lb.mentics-demo.k8s.local"
    "kubernetes.io/cluster/mentics-demo.k8s.local" = "owned"
  }

  tags_all = {
    KubernetesCluster                              = "mentics-demo.k8s.local"
    Name                                           = "lb.mentics-demo.k8s.local"
    "kubernetes.io/cluster/mentics-demo.k8s.local" = "owned"
  }

  vpc_id = "vpc-03534cadfc62a6d5c"
}
