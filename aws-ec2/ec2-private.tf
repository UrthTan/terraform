# AWS EC2 Instance Terraform Module
# Bastion Host - EC2 Instance that will be created in VPC Public Subnet

module "ec2_private" {
  depends_on = [
    module.vpc
  ]
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "3.1.0"

  for_each               = module.vpc.private_subnets
  name                   = "${var.environment}-private-vm-${count.index}"
  ami                    = data.aws_ami.amzlinux2.id
  instance_type          = var.instance_type
  key_name               = var.aws_key_pair_name
  user_data              = file("${path.module}/app-install.sh")
  vpc_security_group_ids = module.private_sg.security_group_id
  tags                   = local.common_tags
  subnet_id              = each.value
}