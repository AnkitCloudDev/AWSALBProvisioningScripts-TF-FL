variable "ingress_rules" {
  type    = list(number)
  default = [22, 8080]
}
variable "egress_rules" {
  type    = list(number)
  default = [22, 8080]
}


resource "aws_vpc" "vpc1" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.vpc1.id}"

  tags = {
    Name = "main"
  }
}
resource "aws_subnet" "sub1" {
  vpc_id            = "${aws_vpc.vpc1.id}"
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "sub2" {
  vpc_id            = "${aws_vpc.vpc1.id}"
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
}

resource "aws_security_group" "sg" {
  vpc_id = "${aws_vpc.vpc1.id}"
  name   = "ssh and web"
  dynamic "ingress" {
    iterator = port
    for_each = var.ingress_rules
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  dynamic "egress" {
    iterator = port
    for_each = var.egress_rules
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}


resource "aws_lb" "test" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.sg.id}"]

  subnet_mapping {
    subnet_id = "${aws_subnet.sub1.id}"

  }
  subnet_mapping {
    subnet_id = "${aws_subnet.sub2.id}"

  }

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = "${aws_lb.test.arn}"
  port              = "8080"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.test.arn}"
  }
}


resource "aws_lb_target_group" "test" {
  name     = "tf-example-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.vpc1.id}"
}

