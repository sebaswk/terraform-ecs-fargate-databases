resource "aws_security_group" "BastionSecurityGroup" {
  name   = "SgBastion"
  vpc_id = var.id_vpc

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "All"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SgBastion"
    Type = "Terraform"
  }
}

resource "aws_security_group" "PublicAlbSecurityGroup" {
  name   = "SgPublicAlb"
  vpc_id = var.id_vpc

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "All"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SgPublicAlb"
    Type = "Terraform"
  }
}

resource "aws_security_group" "WebSecurityGroup" {
  name   = "SgWebInstances"
  vpc_id = var.id_vpc

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.BastionSecurityGroup.id]
  }

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.PublicAlbSecurityGroup.id]
  }

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.PublicAlbSecurityGroup.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "All"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SgWebInstances"
    Type = "Terraform"
  }
}

resource "aws_security_group" "DatabaseSQLSecurityGroup" {
  name   = "SgDatabaseSQL"
  vpc_id = var.id_vpc

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.subnet_private_cidr}"]
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.BastionSecurityGroup.id]
  }

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.BastionSecurityGroup.id]
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["${var.subnet_private_cidr}", "${var.subnet_isolated_cidr}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "All"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SgDatabaseSQL"
    Type = "Terraform"
  }
}

resource "aws_security_group" "DatabasePostgresSecurityGroup" {
  name   = "SgDatabasePostgres"
  vpc_id = var.id_vpc

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.WebSecurityGroup.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "All"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SgDatabasePostgres"
    Type = "Terraform"
  }
}
