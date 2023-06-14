data "aws_iam_policy" "SSMEc2Policy" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role" "IamRoleEc2SSM" {
  name               = "IamRoleEc2SSM${var.project_name}"
  assume_role_policy = <<EOF
{
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
}
EOF
}

resource "aws_iam_role_policy_attachment" "policy_attachment" {
  role       = aws_iam_role.IamRoleEc2SSM.name
  policy_arn = data.aws_iam_policy.SSMEc2Policy.arn
}

resource "aws_iam_instance_profile" "IamInstaceProfileBastion" {
  name = "IamInstaceProfileBastion${var.project_name}"
  role = aws_iam_role.IamRoleEc2SSM.name
}
