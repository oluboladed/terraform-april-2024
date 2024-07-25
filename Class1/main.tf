resource "aws_iam_user" "lb" {
  name = "loadbalancer"
}

resource "aws_iam_user" "lb2" {
  name = "loadbalancer2"
}

resource "aws_iam_group" "developers" {
  name = "developers"
  
}