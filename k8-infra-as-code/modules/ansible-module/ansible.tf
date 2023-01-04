data "aws_ami" "ansible-base-ami" {
  most_recent = true
  owners      = [var.ami_owner]

  filter {
    name   = "name"
    values = [var.ansible_ami_name]
  }
}
resource "aws_launch_template" "ansible-lt" {
  count         = var.create_ansible_cp ? 1 : 0
  name_prefix   = "ansible-lt"
  image_id      = data.aws_ami.ansible-base-ami.id
  instance_type = var.ansible_instance_type
  ebs_optimized = true
  # vpc_security_group_ids = [var.ansible_security_group_id]
  network_interfaces {
    security_groups             = [var.ansible_security_group_id]
    associate_public_ip_address = true
  }

  iam_instance_profile {
    arn = var.ansible-node-instance-profile-arn
  }
  monitoring {
    enabled = true
  }
  tag_specifications {
    resource_type = "instance"

    tags = merge({
      Name = "k8-ansible"
      },
      var.tags
    )
  }
  lifecycle {
    create_before_destroy = true
  }
}
## ansible
resource "aws_autoscaling_group" "ansible" {
  count            = var.create_ansible_cp ? 1 : 0
  max_size         = var.ansible_max_size
  min_size         = var.ansible_min_size
  desired_capacity = var.ansible_size
  force_delete     = true
  launch_template {
    id      = aws_launch_template.ansible-lt[0].id
    version = "$Latest"
  }
  vpc_zone_identifier = [var.ansible_subnet]
  tags = [merge(
    {
      key                 = "Name"
      value               = "k8-ansible-ASG"
      propagate_at_launch = true
    },
    {
      key                 = "Owner"
      value               = "Logging Kibana Team"
      propagate_at_launch = true
    }
  )]
}




