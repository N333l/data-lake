
provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_security_group" "web_sg" {
  name        = "web_sg"
  description = "Allow HTTP and SSH"

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

resource "aws_instance" "web_instance" {
  ami           = var.base_ami
  instance_type = var.instance_type
  security_groups = [aws_security_group.web_sg.name]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "Hello from Terraform EC2" > /var/www/html/index.html
              EOF

  tags = {
    Name = "WebServer-1"
  }
}

resource "aws_ami_from_instance" "custom_ami" {
  name               = "custom-ami-terraform"
  source_instance_id = aws_instance.web_instance.id
}

resource "aws_instance" "clone_instance" {
  ami           = aws_ami_from_instance.custom_ami.id
  instance_type = var.instance_type
  security_groups = [aws_security_group.web_sg.name]

  tags = {
    Name = "WebServer-Clone"
  }
}
