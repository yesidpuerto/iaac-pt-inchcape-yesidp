provider "aws" {
  profile = "ptyesidp" # nombre del perfil usado en la configuracion para la cuenta correspondiente
  region  = "us-east-1"
}

resource "aws_instance" "app" {
  ami           = "ami-0c7217cdde317cfec"  # Usa el ID de AMI correcto
  instance_type = "t2.micro"
  key_name      = "ptyesidp"  # Asociar la instancia EC2 con el par de claves previamente generado

  tags = {
    Name = "app-instance-pt"
  }

  vpc_security_group_ids = [aws_security_group.app.id]
  
}

resource "aws_security_group" "app" {
  name        = "app-sg"
  description = "Grupo de seguridad para la aplicacion"

  ingress {
    from_port = 22
    to_port   = 22
    protocol = "tcp"
    cidr_blocks = ["181.51.52.210/32"]  # Permitir SSH solo desde la IP especificada
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Permitir todo el tráfico HTTP
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Permitir todo el tráfico HTTPS
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Permitir todo el tráfico saliente
  }
}

resource "aws_eip" "nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "app" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route" "public_to_nat" {
  route_table_id = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.app.id
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

resource "aws_subnet" "public" {
  vpc_id        = aws_vpc.main.id
  cidr_block    = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  map_public_ip_on_launch = true
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}


output "public_ip" {
  value = aws_instance.app.public_ip
}
