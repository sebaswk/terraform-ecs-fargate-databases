data "aws_region" "current" {}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners = [ "099720109477" ]

  filter {
    name = "name"
    values = [ "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-20230516" ]
  }
}

resource "aws_iam_role" "role" {
  name = "RoleEc2Db${var.project_name}"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "role_attach" {
  role = aws_iam_role.role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "iam_profile" {
  name = "RoleEc2Db${var.project_name}"
  role = aws_iam_role.role.name
}

resource "aws_ebs_volume" "volume" {
  count             = var.db_count
  availability_zone = "${data.aws_region.current.name}${substr(keys(var.subnets_sql)[count.index], -1, -1)}"
  size              = var.disk_size
  type              = "gp3"
  encrypted         = false
  tags = {
    Name  = "VolumeEc2Db${var.project_name}${count.index + 1}"
    Owner = "Ec2Db${var.project_name}${count.index + 1}"
  }
}

resource "aws_volume_attachment" "ebs_att" {
  count       = var.db_count
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.volume[count.index].id
  instance_id = aws_instance.instances_sql[count.index].id
}

resource "aws_instance" "instances_sql" {
  count                  = var.db_count
  ami                    = data.aws_ami.ubuntu.id
  subnet_id              = values(var.subnets_sql)[count.index]
  instance_type          = var.instance_type_ec2db
  user_data              = "${file("modules/ec2-database/userdata.tpl")}"
  key_name               = var.key_account
  iam_instance_profile   = aws_iam_instance_profile.iam_profile.name
  vpc_security_group_ids = [var.security_group_dbsql]

  root_block_device {
    volume_size = 50
    volume_type = "gp3"
    encrypted   = false
  }

  tags = {
    Name = "Ec2Db${var.project_name}${count.index + 1}"
    Type = "Terraform"
  }
}
