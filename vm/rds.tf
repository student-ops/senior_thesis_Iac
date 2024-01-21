resource "aws_db_subnet_group" "praivate-db" {
  name       = "praivate-db"
  subnet_ids = ["${aws_subnet.private-db1.id}", "${aws_subnet.private-db2.id}"]
  tags = {
    Name = "praivate-db"
  }
}

resource "aws_db_instance" "test-db" {
  identifier             = "test-db"
  allocated_storage      = 10
  storage_type           = "gp2"
  engine                 = "postgres"
  engine_version         = "14.10"
  instance_class         = "db.t3.micro"
  db_name                = "testdb"
  username               = "test"
  password               = "password"
  vpc_security_group_ids = ["${aws_security_group.praivate-db-sg.id}"]
  db_subnet_group_name   = aws_db_subnet_group.praivate-db.name
  skip_final_snapshot    = true
}


output "db_connection_string" {
  value     = "mysql -u ${aws_db_instance.test-db.username} -p${aws_db_instance.test-db.password} -h ${aws_db_instance.test-db.endpoint} -P ${aws_db_instance.test-db.port}"
  sensitive = true
}
