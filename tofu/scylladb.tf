resource "aws_instance" "scylladb_ec2" {
    ami = "ami-0cf9b940f04a883a1"
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
        volume_size           = 30
        volume_type           = "gp3"
    }

    ebs_block_device {
        delete_on_termination = true
        device_name           = "/dev/sdb"
        encrypted             = false
        iops                  = 3000
        throughput            = 125
        volume_size           = 8
        volume_type           = "gp3"
    }

    metadata_options {
        http_endpoint               = "enabled"
        http_protocol_ipv6          = "disabled"
        http_put_response_hop_limit = 1
        http_tokens                 = "optional"
        instance_metadata_tags      = "disabled"
    }

    user_data = jsonencode({
            "scylla_yaml": {
                "cluster_name": "mentics-demo",
                "experimental": true,
                "developer_mode": true
            }
    })

    vpc_security_group_ids = [aws_security_group.nodes-mentics-demo-k8s-local.id]
    subnet_id = aws_subnet.us-west-2b-mentics-demo-k8s-local.id

    tags = {
        Name = "ScyllaDB"
    }
}