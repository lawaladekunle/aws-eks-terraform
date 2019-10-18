resource "aws_autoscaling_group" "prod" {
  desired_capacity     = 2
  launch_configuration = "${aws_launch_configuration.prod.id}"
  max_size             = 2
  min_size             = 1
  name                 = "terraform-eks-prod"
  vpc_zone_identifier  = "${aws_subnet.prod[*].id}"

  tag {
    key                 = "Name"
    value               = "terraform-eks-prod"
    propagate_at_launch = true
  }

  tag {
    key                 = "kubernetes.io/cluster/${var.cluster-name}"
    value               = "owned"
    propagate_at_launch = true
  }
}
