# VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "dev_vpc"
  }
}
resource "aws_subnet" "subnet-1" {
    vpc_id = aws_vpc.my_vpc.id
    cidr_block = "10.0.0.0/24"
    availability_zone = "eu-north-1a"
    tags = {
      "Name" = "subnet-1"
    }
}
resource "aws_subnet" "subnet-2" {
    vpc_id = aws_vpc.my_vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "eu-north-1b"
    tags = {
      "Name" = "subnet-2"
    }
}
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.my_vpc.id
    tags = {
      Name = "igw"
    }
}
resource "aws_route_table" "rt-1" {
    vpc_id = aws_vpc.my_vpc.id
    route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.igw.id
    }
}
resource "aws_route_table_association" "subnet-1" {
    subnet_id = aws_subnet.subnet-1.id
    route_table_id = aws_route_table.rt-1.id  
}
resource "aws_route_table_association" "subnet-2" {
    subnet_id = aws_subnet.subnet-2.id
    route_table_id = aws_route_table.rt-1.id  
}
resource "aws_db_subnet_group" "snetgroup" {
    name = "my-subnet-group"
    subnet_ids = [aws_subnet.subnet-1.id, aws_subnet.subnet-2.id]  
}
resource "aws_security_group" "my_sg" {
    name = "my-sg"
    description = "Allow SSH and HTTP traffic"
    vpc_id = aws_vpc.my_vpc.id
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]    
    }
}
resource "aws_db_instance" "mydb-1" {
    allocated_storage = 20
    engine = "mysql"
    engine_version = "8.0"
    instance_class = "db.t3.micro"
    identifier = "mydb-1"
    username = "vishal"
    password = "vishal123"
    db_subnet_group_name = aws_db_subnet_group.snetgroup.name
    vpc_security_group_ids = [aws_security_group.my_sg.id]
    skip_final_snapshot = true
    maintenance_window = "Mon:00:00-Mon:03:00"
    backup_retention_period = 1
}
# RDS Read Replica
resource "aws_db_instance" "mybd-1-replica" {
    identifier = "mydb-replica"
    replicate_source_db = aws_db_instance.mydb-1.arn
    instance_class = "db.t3.micro"
    publicly_accessible = false
    skip_final_snapshot = true
    tags = {
        Name = "mydb-replica"
    }
}
resource "aws_elasticache_subnet_group" "redis_subnet_grp" {
    name = "redis-snet-grp"
    subnet_ids = [aws_subnet.subnet-1.id, aws_subnet.subnet-2.id]
}
resource "aws_security_group" "redis_sg" {
    name = "redis-sg"
    description = "Allow Redis traffic"
    vpc_id = aws_vpc.my_vpc.id
    ingress {
        from_port = 6379
        to_port = 6379
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
resource "aws_elasticache_replication_group" "redis" {
    replication_group_id = "my-redis-replication-group"
    description = "Redis replication group"
    engine = "redis"
    node_type = "cache.t3.micro"
    num_cache_clusters = 1
    automatic_failover_enabled = false
    subnet_group_name = aws_elasticache_subnet_group.redis_subnet_grp.name
    security_group_ids = [aws_security_group.redis_sg.id]
    tags = {
        Name = "my-redis-cache"
    }
}