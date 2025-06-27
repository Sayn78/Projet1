provider "aws" {
  region = "eu-west-3" #Paris
}

resource "aws_security_group" "web_sg" {
  name        = "web_sg"
  description = "Allow HTTP and SSH access"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web" {
  ami           = "ami-04ec97dc75ac850b1"
  instance_type = "t2.micro"
  key_name      = "sshsenan"
  security_groups = [aws_security_group.web_sg.name]

  tags = {
    Name = "web_server1"
  }
}

resource "aws_eip" "web_ip" {
  instance = aws_instance.web.id
}

