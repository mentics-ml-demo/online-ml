resource "aws_ec2_instance_connect_endpoint" "mentics_demo_eice" {
    subnet_id = aws_subnet.us-west-2b-mentics-demo-k8s-local.id
    tags = {
        Name = "Kubernetes Instance Endpiont"
    }
}
