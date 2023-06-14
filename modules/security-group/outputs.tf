output "bastion_security_group_id" {
  value = aws_security_group.BastionSecurityGroup.id
}

output "dbsql_security_group_id" {
  value = aws_security_group.DatabaseSQLSecurityGroup.id
}

output "dbpostgres_security_group_id" {
  value = aws_security_group.DatabasePostgresSecurityGroup.id
}

output "publicalb_security_group_id" {
  value = aws_security_group.PublicAlbSecurityGroup.id
}

output "web_security_group_id" {
  value = aws_security_group.WebSecurityGroup.id
}