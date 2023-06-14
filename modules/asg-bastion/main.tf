resource "aws_launch_template" "bastion" {
  name          = "LaunchTemplateBastion${var.project_name}"
  image_id      = var.bastion_ami
  instance_type = var.instance_type_bastion
  key_name      = var.key_account
  iam_instance_profile {
    name = aws_iam_instance_profile.IamInstaceProfileBastion.name
  }
  vpc_security_group_ids = [var.security_group_asg]
  tags = {
    Name : "${var.project_name}-launch-template"
    Type : "Terraform"
  }
}

resource "aws_autoscaling_group" "asg_bastion" {
  name                = "AsgBastion${var.project_name}"
  vpc_zone_identifier = var.subnets_asg
  desired_capacity    = var.desired_capacity_min_max
  max_size            = var.desired_capacity_min_max
  min_size            = var.desired_capacity_min_max

  tag {
    key                 = "Name"
    value               = "Ec2Bastion${var.project_name}"
    propagate_at_launch = true
  }

  launch_template {
    id      = aws_launch_template.bastion.id
    version = "$Latest"
  }
}
