# Data sources
## Ubuntu AMI for all K8s instances
data "aws_ami" "k8-base-ami" {
  most_recent = true
  owners      = [var.ami_owner]

  filter {
    name   = "name"
    values = [var.k8_cp_ami_name]
  }
}

resource "aws_launch_template" "k8-etcd-lt" {
  name_prefix   = "k8-etcd-lt"
  image_id      = data.aws_ami.k8-base-ami.id
  instance_type = var.etcd_instance_type
  ebs_optimized = true
  # vpc_security_group_ids = [var.k8_nodes_security_group_id]
  network_interfaces {
    security_groups             = [var.k8_nodes_security_group_id]
    associate_public_ip_address = false
  }

  iam_instance_profile {
    arn = var.k8-node-instance-profile-arn
  }
  monitoring {
    enabled = true
  }
  tag_specifications {
    resource_type = "instance"

    tags = merge({
      Name = "k8-etcd"
      },
      var.tags
    )
  }
  lifecycle {
    create_before_destroy = true
  }
}

# resource "aws_launch_configuration" "k8-etcd-lc" {
#   name            = "k8-etcd-lc"
#   image_id        = data.aws_ami.k8-base-ami.id
#   instance_type   = var.etcd_instance_type
#   security_groups = [var.k8_nodes_security_group_id]
#   //key_name                    = var.aws_key_pair_name == null ? aws_key_pair.ssh.0.key_name : var.aws_key_pair_name
#   associate_public_ip_address = false
#   ebs_optimized               = true
#   enable_monitoring           = true
#   iam_instance_profile        = var.k8-node-instance-profile-arn

#   # Important note: whenever using a launch configuration with an auto scaling group, you must set
#   # create_before_destroy = true. However, as soon as you set create_before_destroy = true in one resource, you must
#   # also set it in every resource that it depends on, or you'll get an error about cyclic dependencies (especially when
#   # removing resources). For more info, see:
#   #
#   # https://www.terraform.io/docs/providers/aws/r/launch_configuration.html
#   # https://terraform.io/docs/configuration/resources.html
#   lifecycle {
#     create_before_destroy = true
#   }
# }

# ## Kubernetes Master
# resource "aws_launch_configuration" "k8-master-lc" {
#   name_prefix     = "k8-master-lc"
#   image_id        = data.aws_ami.k8-base-ami.id
#   instance_type   = var.master_instance_type
#   security_groups = [var.k8_nodes_security_group_id]
#   #   key_name                    = var.aws_key_pair_name == null ? aws_key_pair.ssh.0.key_name : var.aws_key_pair_name
#   associate_public_ip_address = false
#   ebs_optimized               = true
#   enable_monitoring           = true
#   iam_instance_profile        = var.k8-node-instance-profile-arn
#   #   user_data = templatefile("${path.module}/userdata.tpl", {
#   #     domain = var.hosted_zone
#   #   })

#   lifecycle {
#     create_before_destroy = true
#   }
# }

resource "aws_launch_template" "k8-master-lt" {
  name_prefix   = "k8-master-lt"
  image_id      = data.aws_ami.k8-base-ami.id
  instance_type = var.master_instance_type
  ebs_optimized = true
  # vpc_security_group_ids = [var.k8_nodes_security_group_id]
  network_interfaces {
    security_groups             = [var.k8_nodes_security_group_id]
    associate_public_ip_address = false
  }
  iam_instance_profile {
    arn = var.k8-node-instance-profile-arn
  }
  monitoring {
    enabled = true
  }
  tag_specifications {
    resource_type = "instance"

    tags = merge({
      Name = "k8-master"
      },
      var.tags
    )
  }
  lifecycle {
    create_before_destroy = true
  }
}


## etcd
resource "aws_autoscaling_group" "etcd" {
  max_size         = var.etcd_max_size
  min_size         = var.etcd_min_size
  desired_capacity = var.etcd_size
  force_delete     = true
  launch_template {
    id      = aws_launch_template.k8-etcd-lt.id
    version = "$Latest"
  }
  vpc_zone_identifier = [var.cp-subnet]
  tags = [merge(
    {
      key                 = "Name"
      value               = "k8-etcd-ASG"
      propagate_at_launch = false
    },
    {
      key                 = "Owner"
      value               = "Logging Kibana Team"
      propagate_at_launch = false
    }
  )]
}

## Kubernetes Master
resource "aws_autoscaling_group" "master" {
  max_size         = var.master_max_size
  min_size         = var.master_min_size
  desired_capacity = var.master_size
  force_delete     = true
  launch_template {
    id      = aws_launch_template.k8-master-lt.id
    version = "$Latest"
  }
  vpc_zone_identifier = [var.cp-subnet]
  # load_balancers       = [aws_elb.master-public.id, aws_elb.master-private.id]

  tags = [merge(
    {
      key                 = "Name"
      value               = "k8s-master-ASG"
      propagate_at_launch = false
    },
    {
      key                 = "Owner"
      value               = "Logging Kibana Team"
      propagate_at_launch = false
    }
  )]
}