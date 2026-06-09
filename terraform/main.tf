resource "aws_security_group" "project_sg" {
  name        = "Project-SG"
  description = "Allow SSH, HTTP, HTTPS, Jenkins, SonarQube and Application Ports"

  dynamic "ingress" {
    for_each = [22, 80, 443, 8080, 9000, 3000]

    content {
      description = "TCP Port ${ingress.value}"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Project-SG"
  }
}

resource "aws_instance" "web" {
  ami                    = "ami-0ecb62995f68bb549"
  instance_type          = "t3.large"
  key_name               = "cherry"

  vpc_security_group_ids = [
    aws_security_group.project_sg.id
  ]

  user_data = file("${path.module}/resource.sh")

  root_block_device {
    volume_size = 30
    volume_type = "gp3"
  }

  tags = {
    Name = "Swiggy-DevOps-Project"
  }
}

output "instance_public_ip" {
  description = "Public IP of EC2 Instance"
  value       = aws_instance.web.public_ip
}

output "jenkins_url" {
  value = "http://${aws_instance.web.public_ip}:8080"
}

output "sonarqube_url" {
  value = "http://${aws_instance.web.public_ip}:9000"
}

output "application_url" {
  value = "http://${aws_instance.web.public_ip}:3000"
}