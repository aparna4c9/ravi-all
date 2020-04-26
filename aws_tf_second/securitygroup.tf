resource "aws_security_group" "web" {
 name = "abc-web-sg"
 description = "ONLY HTTP CONNECTION INBOUND"
 vpc_id = "${aws_vpc.main.id}"

    ingress {
        from_port = 0
        to_port = 80
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = "22"
        to_port = "22"
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"] 
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"] 
    }
    tags = {
        Name = "abc-web-sg"
        

    }



}
