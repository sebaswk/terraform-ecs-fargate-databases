module "security-group" {
  source = "./modules/security-group"
  id_vpc = var.vpc-id
  subnet_private_cidr = var.subnet_private_cidr
  subnet_isolated_cidr = var.subnet_isolated_cidr
}

module "asg-bastion" {
  source                   = "./modules/asg-bastion"
  project_name             = var.project_name
  security_group_asg       = module.security-group.bastion_security_group_id
  subnets_asg              = var.subnet_public
  key_account              = var.keypair
  bastion_ami              = var.ami_id_bastion
  instance_type_bastion    = var.instance_type
  desired_capacity_min_max = var.desired_capacity_min_max
}

module "alb-ecs" {
  source             = "./modules/ecs/alb-ecs"
  id_vpc             = var.vpc-id
  project_name       = var.project_name
  subnets_alb        = var.subnet_public
  security_group_alb = module.security-group.publicalb_security_group_id
  app_port           = var.docker_port
  target_port        = var.target_group_port
}

module "ecs" {
  source                     = "./modules/ecs"
  project_name               = var.project_name
  subnets_asg_cluster        = var.subnet_private
  security_group_asg_cluster = [module.security-group.web_security_group_id]
  key_account                = var.keypair
  tg_ecs                     = [module.alb-ecs.aws_alb_target_group]
  ami_id_ecs_cluster         = var.ami_id_ecs_cluster
  instance_type_ecs          = var.instance_type_ecs
  app_logs                   = var.app_logs
  app_image                  = var.app_image
  target_group_port          = var.target_group_port
  task_cpu                   = var.task_cpu
  task_memory                = var.task_memory
  app_count                  = var.app_count
  tg_service                 = module.alb-ecs.aws_alb_target_group
  alb_listener_ecs           = module.alb-ecs.aws_alb_listener_ecs
}

module "ec2" {
  source               = "./modules/ec2-database"
  project_name         = var.project_name
  db_count             = var.count_databases
  id_vpc               = var.vpc-id
  subnets_sql          = var.subnet_isolated
  key_account          = var.keypair
  security_group_dbsql = module.security-group.dbsql_security_group_id
  instance_type_ec2db  = var.instance_type_ec2db
  disk_size            = var.disk_size
}
