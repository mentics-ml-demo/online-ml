module "fck-nat" {
  source = "RaJiska/fck-nat/aws"

  name                 = "mentics-demo.nat"
  instance_type = "t4g.small"
  vpc_id               = aws_vpc.mentics-demo-k8s-local.id
  subnet_id            = aws_subnet.utility-us-west-2b-mentics-demo-k8s-local.id
  update_route_table = true
  route_table_id = aws_route_table.private-us-west-2b-mentics-demo-k8s-local.id

  encryption = false
  ha_mode = false
  use_cloudwatch_agent = false
}
