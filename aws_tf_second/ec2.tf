
data "aws_ami" "ubuntu" {
  most_recent = true
  owners = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}

resource "aws_instance" "web" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "${var.ec2_size}"
  associate_public_ip_address = true
  subnet_id      = "${aws_subnet.mysubnet.id}"
  key_name       = "${var.key_name}"
  vpc_security_group_ids = ["${aws_security_group.web.id}"]
  tags = {
    Name = "abc-web-1"
  }
}


output "ec2_public_ip" {

  value = "${aws_instance.web.public_ip}"
}

