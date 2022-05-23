### Creating random pwd ### 
resource "random_password" "password" {
  length  = 16
  special = false
}

resource "aws_rds_cluster_parameter_group" "create-mysql-pg" {
  name        = "mysql-pg-28cld-db"
  family      = "aurora-mysql8.0"
  description = "RDS cluster parameter group"
}

resource "aws_rds_cluster" "create-mysql-cluster" {
  cluster_identifier              = "mysql-28cld-db"
  engine                          = "aurora-mysql"
  engine_version                  = "8.0.mysql_aurora.3.01.0"
  deletion_protection             = false
  storage_encrypted               = false
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.create-mysql-pg.name
  vpc_security_group_ids          = [aws_security_group.database.id]
  db_subnet_group_name            = aws_db_subnet_group.create-sb-grp.name
  master_username                 = "foo"
  master_password                 = random_password.password.result
  skip_final_snapshot             = true
}

resource "aws_rds_cluster_instance" "cluster-mysql-instances" {
  count                = var.mysql_instances
  identifier           = "mysql-28cld-db-${count.index}"
  cluster_identifier   = aws_rds_cluster.create-mysql-cluster.id
  instance_class       = var.database_instance_type
  engine               = aws_rds_cluster.create-mysql-cluster.engine
  engine_version       = aws_rds_cluster.create-mysql-cluster.engine_version
  db_subnet_group_name = aws_db_subnet_group.create-sb-grp.name
}

resource "aws_db_subnet_group" "create-sb-grp" {
  name       = "database-28cld-sb"
  subnet_ids = aws_subnet.database_subnets.*.id

  tags = {
    Name = "Database Subnet Group"
  }
}