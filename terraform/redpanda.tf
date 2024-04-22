resource "aws_instance" "redpanda" {
    ami = "ami-01a43c6864f47cef1"
    instance_type = "t4g.small"
    availability_zone = "us-west-2b"

    associate_public_ip_address = false
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

    vpc_security_group_ids = [aws_security_group.nodes-mentics-demo-k8s-local.id]
    subnet_id = aws_subnet.us-west-2b-mentics-demo-k8s-local.id

    tags = {
        Name = "redpanda"
    }
}