# This data source is included for ease of sample architecture deployment
# and can be swapped out as necessary.
data "aws_region" "current" {}

# EKS currently documents this required userdata for EKS worker nodes to
# properly configure Kubernetes applications on the EC2 instance.
# We implement a Terraform local here to simplify Base64 encoding this
# information into the AutoScaling Launch Configuration.
# More information: https://docs.aws.amazon.com/eks/latest/userguide/launch-workers.html
locals {
  prod-node-userdata = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --apiserver-endpoint '${aws_eks_cluster.prod.endpoint}' --b64-cluster-ca '${aws_eks_cluster.prod.certificate_authority.0.data}' '${var.cluster-name}'
USERDATA
}

resource "aws_launch_configuration" "prod" {
  associate_public_ip_address = true
  iam_instance_profile        = "${aws_iam_instance_profile.prod-node.name}"
  image_id                    = "${data.aws_ami.eks-worker.id}"
  instance_type               = "t2.medium"
  name_prefix                 = "terraform-eks-prod"
  security_groups             = ["${aws_security_group.prod-node.id}"]
  user_data_base64            = "${base64encode(local.prod-node-userdata)}"

  lifecycle {
    create_before_destroy = true
  }

}
