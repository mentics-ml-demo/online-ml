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
    source_dest_check = false

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

    tags = {
        Name = "HAProxy"
    }
}

resource "aws_security_group" "load_balancer" {
  name        = "lb.mentics-demo.k8s.local"
  description = "Security group for load balancer"
  vpc_id = aws_vpc.mentics-demo-k8s-local.id

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
}

resource "aws_security_group" "masters-mentics-demo-k8s-local" {
  name        = "masters.mentics-demo.k8s.local"
  description = "Security group for masters"
  vpc_id = aws_vpc.mentics-demo-k8s-local.id

  egress {
    cidr_blocks      = ["0.0.0.0/0"]
    from_port        = "0"
    ipv6_cidr_blocks = ["::/0"]
    protocol         = "-1"
    self             = "false"
    to_port          = "0"
  }

  tags = {
    "KubernetesCluster"                            = "mentics-demo.k8s.local"
    "Name"                                         = "masters.mentics-demo.k8s.local"
    "kubernetes.io/cluster/mentics-demo.k8s.local" = "owned"
  }

  tags_all = {
    "KubernetesCluster"                            = "mentics-demo.k8s.local"
    "Name"                                         = "masters.mentics-demo.k8s.local"
    "kubernetes.io/cluster/mentics-demo.k8s.local" = "owned"
  }
}
#      aws_security_group.masters-mentics-demo-k8s-local,

resource "aws_security_group_rule" "ingress-control-to-control" {
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.masters-mentics-demo-k8s-local.id
  source_security_group_id = aws_security_group.masters-mentics-demo-k8s-local.id
  to_port                  = 0
  type                     = "ingress"
}

resource "aws_security_group_rule" "ingress-nodes-to-control" {
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.masters-mentics-demo-k8s-local.id
  source_security_group_id = aws_security_group.nodes-mentics-demo-k8s-local.id
  to_port                  = 0
  type                     = "ingress"
}

resource "aws_security_group_rule" "ingress-ssh-to-control" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port                = 22
  protocol                 = "tcp"
  security_group_id        = aws_security_group.masters-mentics-demo-k8s-local.id
  to_port                  = 22
  type                     = "ingress"
}

resource "aws_security_group_rule" "ingress-lb-to-control" {
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.masters-mentics-demo-k8s-local.id
  source_security_group_id = aws_security_group.load_balancer.id
  to_port                  = 0
  type                     = "ingress"
}

resource "aws_security_group_rule" "ingress-lb-to-nodes" {
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.nodes-mentics-demo-k8s-local.id
  source_security_group_id = aws_security_group.load_balancer.id
  to_port                  = 0
  type                     = "ingress"
}
