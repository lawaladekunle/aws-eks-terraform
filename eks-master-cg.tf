resource "aws_security_group" "prod-cluster" {
  name        = "terraform-eks-prod-cluster"
  description = "Cluster communication with worker nodes"
  vpc_id      = "${aws_vpc.prod.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform-eks-prod"
  }
}

# OPTIONAL: Allow inbound traffic from your local workstation external IP
#           to the Kubernetes. You will need to replace A.B.C.D below with
#           your real IP. Services like icanhazip.com can help you find this.
resource "aws_security_group_rule" "prod-cluster-ingress-workstation-https" {
  cidr_blocks       = ["41.58.239.207/32"]
  description       = "Allow workstation to communicate with the cluster API Server"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = "${aws_security_group.prod-cluster.id}"
  to_port           = 443
  type              = "ingress"
}
