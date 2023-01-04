## Kubernetes Worker
resource "aws_launch_configuration" "worker" {
  name_prefix                 = "worker-"
  image_id                    = data.aws_ami.k8-base-ami.id
  instance_type               = var.worker_instance_type
  security_groups             = [aws_security_group.k8_nodes_security_group.id]
#   key_name                    = var.aws_key_pair_name == null ? aws_key_pair.ssh.0.key_name : var.aws_key_pair_name
  associate_public_ip_address = false
  ebs_optimized               = true
  enable_monitoring           = true
  iam_instance_profile        = aws_iam_instance_profile.k8_instance_profile.id

#   user_data = templatefile("${path.module}/userdata-worker.tpl", {
#     pod_cidr = var.pod_cidr
#     domain   = var.hosted_zone
#   })

  lifecycle {
    create_before_destroy = true
  }
}