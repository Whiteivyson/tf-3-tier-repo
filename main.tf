module "vpc" {
  source = "./vpc"
  tags = local.six-figure-tags
}

module "ec2" {
  source = "./ec2"
  vpc_id = module.vpc.vpc_id
  tags = local.six-figure-tags
  public_sn1_id = module.vpc.public_sn1_id
  public_sn2_id = module.vpc.public_sn2_id
}