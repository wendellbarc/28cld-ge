### Load Balancer SG ###
resource "aws_security_group" "http" {
  name        = "28cld-http-sg"
  description = "Allow HTTP traffic"
  vpc_id      = aws_vpc.create.id

  ingress {
    description = "External Traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "28cld-http-sg"
  }
}

### Security Group SG ###
resource "aws_security_group" "database" {
  name        = "28cld-db-sg"
  description = "Allow MYSQL traffic"
  vpc_id      = aws_vpc.create.id

  ingress {
    description = "Mysql"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.create.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "28cld-db-sg"
  }
}

### Application SG ###
resource "aws_security_group" "app" {
  name        = "28cld-app-sg"
  description = "Allow HTTP traffic"
  vpc_id      = aws_vpc.create.id

  ingress {
    description = "ECS"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.create.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "28cld-app-sg"
  }
}
