# data "aws_iam_policy_document" "etcd_worker_master" {
#   statement {
#     sid = "autoscaling"
#     actions = [
#       "ec2:DescribeAvailabilityZones",
#       "ec2:DescribeInstances",
#       "ec2:DescribeNetworkInterfaces",
#       "ec2:DescribeRegions",
#       "ec2:DescribeRouteTables",
#       "ec2:DescribeTags",
#       "elasticloadbalancing:DescribeLoadBalancers"
#     ]
#     resources = ["*"]
#   }
# }
data "aws_iam_policy" "ReadOnlyAccess" {
  arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

data "aws_iam_policy" "SessionManagerAccess" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role" "ansible-node-role" {
  count               = var.create_ansible_cp ? 1 : 0
  name                = "ansible-node-role"
  assume_role_policy  = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
  }
EOF
  managed_policy_arns = [data.aws_iam_policy.ReadOnlyAccess.arn, data.aws_iam_policy.SessionManagerAccess.arn]
  tags = merge(
    {
      "Component" = "Ansible-Node-IAM-ROLE"
    },
    var.tags,
  )
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role" "k8-node-role" {
  name                = "k8-node-role"
  assume_role_policy  = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
  }
EOF
  managed_policy_arns = [data.aws_iam_policy.SessionManagerAccess.arn]
  tags = merge(
    {
      "Component" = "K8-Node-IAM-ROLE"
    },
    var.tags,
  )
  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_iam_instance_profile" "ansible_instance_profile" {
  count = var.create_ansible_cp ? 1 : 0
  role  = aws_iam_role.ansible-node-role[0].name
  # aws_launch_configuration.launch_configuration in this module sets create_before_destroy to true, which means
  # everything it depends on, including this resource, must set it as well, or you'll get cyclic dependency errors
  # when you try to do a terraform destroy.
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_instance_profile" "k8_instance_profile" {
  role = aws_iam_role.k8-node-role.name

  # aws_launch_configuration.launch_configuration in this module sets create_before_destroy to true, which means
  # everything it depends on, including this resource, must set it as well, or you'll get cyclic dependency errors
  # when you try to do a terraform destroy.
  lifecycle {
    create_before_destroy = true
  }
}