
provider "aws" {}

resource "aws_instance" "nginx01" {
  ami = "ami-075b44448d2276521"
  instance_type = "t2.micro"
  key_name = "NicoKey"
  vpc_security_group_ids = ["${aws_security_group.nginx01_SEC.id}"]

provisioner "remote-exec" {
  inline=[
  "sudo apt update",
  "sudo apt install -y python",
  ]
}

connection {
  user = "ubuntu"
  private_key = "${file("/home/NicoKey.pem")}"
  }


tags { 
  Name = "nginx01"
    }
}


resource "aws_db_instance" "DBweb" {
  allocated_storage    = 10
  engine               = "mariadb"
  engine_version       = "10.2.12"
  instance_class       = "db.t2.micro"
  name                 = "DBweb"
  username             = "Nico"
  password             = "User.123"
  vpc_security_group_ids = ["${aws_security_group.DBweb_SEC.id}"]
  publicly_accessible = "true"
}

resource "aws_security_group" "nginx01_SEC" {
  name = "Sec_GRP_WEB"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }

  ingress {
     from_port = 22
     to_port = 22
     protocol =  "tcp"
     cidr_blocks = ["0.0.0.0/0"]
   }

  egress {
     from_port = 0
     to_port = 0
     protocol = "-1"
     cidr_blocks = ["0.0.0.0/0"]
  }
} 

resource "aws_security_group" "DBweb_SEC" {
  name = "Sec_GRP_DB"

  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = ["80.11.25.232/32"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "public_ip_nginx01" {
  value = "${aws_instance.nginx01.public_ip}"
}
  
output "dns_public_nginx01" {
  value = "${aws_instance.nginx01.public_dns}"
}
