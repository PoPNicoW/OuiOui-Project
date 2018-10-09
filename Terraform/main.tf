
provider "aws" {}

resource "aws_instance" "nginx01" {
  ami = "ami-075b44448d2276521"
  instance_type = "t2.micro"
  vpc_security_ids = ["${aws_security_group.nginx01_SEC.id}"]

tags { 
  Name = "nginx01"
    }
}


resource "aws_security_group" "nginx01_SEC" {
  name = "Sec_GRP_WEB"

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }
}


  
