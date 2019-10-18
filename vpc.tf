# This data source is included for ease of sample architecture deployment
# and can be swapped out as necessary.
data "aws_availability_zones" "available" {}

resource "aws_vpc" "prod" {
  cidr_block = "10.0.0.0/16"

  tags = "${
    map(
      "Name", "terraform-eks-prod-node",
      "kubernetes.io/cluster/${var.cluster-name}", "shared",
    )
  }"
}

resource "aws_subnet" "prod" {
  count = 2

  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block        = "10.0.${count.index}.0/24"
  vpc_id            = "${aws_vpc.prod.id}"

  tags = "${
    map(
      "Name", "terraform-eks-prod-node",
      "kubernetes.io/cluster/${var.cluster-name}", "shared",
    )
  }"
}

resource "aws_internet_gateway" "prod" {
  vpc_id = "${aws_vpc.prod.id}"

  tags = {
    Name = "terraform-eks-prod"
  }
}

resource "aws_route_table" "prod" {
  vpc_id = "${aws_vpc.prod.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.prod.id}"
  }
}

resource "aws_route_table_association" "prod" {
  count = 2

  subnet_id      = "${aws_subnet.prod.*.id[count.index]}"
  route_table_id = "${aws_route_table.prod.id}"
}
