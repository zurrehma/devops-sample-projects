output "k8-node-sg-id" {
  value = aws_security_group.k8_nodes_security_group.id
}

output "ansible-node-sg-id" {
  value = var.create_ansible_cp ? aws_security_group.ansible_security_group[0].id : null
}

output "k8-node-instance-profile-arn" {
  value = aws_iam_instance_profile.k8_instance_profile.arn
}

output "ansible-node-instance-profile-arn" {
  value = var.create_ansible_cp ? aws_iam_instance_profile.ansible_instance_profile[0].arn : null
}