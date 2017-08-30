provider "aws" {
  region = "${var.region}"
}

resource "aws_security_group" "default"{
  name = "metricssg"

  ingress {
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "default" {
  key_name = "metricskp"
  key_path = "${file(${var.key_path})}"
}

resource "aws_instance" "default" {
  ami = "${var.ami}"
  instance_type = "${var.instance_type}"
  key_name = "${aws_key_pair.default.id}"
  vpc_security_group_ids = ["${aws_security_group.default.id}"]
  user_data = "${file("bootstrap.sh")}" 

  tags {
    Name = "athena"
  }
}