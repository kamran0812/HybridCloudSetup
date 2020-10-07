provider "aws" {
  region  = "ap-south-1"
  profile = "default"

}




resource "aws_security_group" "rds_sec" {
  name        = "main_rds_sg"
  description = "Allow all inbound traffic"


  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "wordpress-db"
  }
}



resource "aws_db_instance" "wordpress" {
  allocated_storage      = "5"
  publicly_accessible    = true
  identifier             = "wordpress-db"
  engine                 = "mariadb"
  engine_version         = "10.4.8"
  instance_class         = "db.t2.micro"
  name                   = "wordpressdb"
  username               = "wordpressdb"
  password               = "password"
  vpc_security_group_ids = [aws_security_group.rds_sec.id]

  skip_final_snapshot = true
}
