resource "aws_security_group_rule" "prod-cluster-ingress-node-https" {
  description              = "Allow pods to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.prod-cluster.id}"
  source_security_group_id = "${aws_security_group.prod-node.id}"
  to_port                  = 443
  type                     = "ingress"
}
