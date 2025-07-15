provider "aws" {
  region = "eu-west-3"  # Paris
}

# Utiliser un data source pour vérifier si le groupe de sécurité existe déjà
data "aws_security_group" "existing_web_sg" {
  filter {
    name   = "group-name"
    values = ["web_sg"]
  }

}

# Si le groupe de sécurité n'existe pas, le créer
resource "aws_security_group" "web_sg" {
  count = length(data.aws_security_group.existing_web_sg.id) == 0 ? 1 : 0  # Créer le groupe uniquement s'il n'existe pas

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


  ingress {
    from_port   = 443
    to_port     = 443
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

# Créer l'instance
resource "aws_instance" "web" {
  ami           = "ami-04ec97dc75ac850b1"
  instance_type = "t2.micro"
  key_name      = "sshsenan"
  security_groups = length(data.aws_security_group.existing_web_sg.id) > 0 ? [data.aws_security_group.existing_web_sg.name] : [aws_security_group.web_sg[0].name]  # Référence le groupe de sécurité existant ou créé

  tags = {
    Name = "web_server1"
  }
}

# Elastic IP associé à l'instance
resource "aws_eip" "web_ip" {
  instance = aws_instance.web.id
}

# Définir la sortie de l'IP publique
output "public_ip" {
  value = aws_instance.web.public_ip
}

# Output pour l'ID de l'instance EC2
output "instance_id" {
  value = aws_instance.web.id
}

