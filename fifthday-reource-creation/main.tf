# VPC
resource "aws_vpc" "dev" {
    cidr_block = "10.0.0.0/16"
    tags = {
      Name = "dev"
    }  
}
# Subnet
resource "aws_subnet" "subnet-1" {
    cidr_block = "10.0.0.0/24"
    vpc_id = aws_vpc.dev.id
    tags = {
        Name = "subnet-1"
    }  
}
# Internet Gateway
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.dev.id
    tags = {
      Name = "igw"
    }
}
# Route Table
resource "aws_route_table" "rt-1" {
    vpc_id = aws_vpc.dev.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
}
# Route table assosiation
resource "aws_route_table_association" "public" {
    subnet_id = aws_subnet.subnet-1.id
    route_table_id = aws_route_table.rt-1.id
  
}
# EC2 Instance
resource "aws_instance" "dev-server" {
    ami = "ami-0493a9ae0eaf18f4c"
    instance_type = "t3.small"
    subnet_id = aws_subnet.subnet-1.id
    associate_public_ip_address = true
    tags = {
      Name = "dev-server"
    }
}
# Subnet-2
resource "aws_subnet" "subnet-2" {
    vpc_id = aws_vpc.dev.id
    cidr_block = "10.0.1.0/24"
    tags = {
      Name = "subnet-2"
    }
}
# Create EIP
resource "aws_eip" "eip" {
    domain = "vpc"
    tags = {
        Name = "nat-eip"
    }
}
# Nat gateway
resource "aws_nat_gateway" "nat" {
    allocation_id = aws_eip.eip.id
    subnet_id = aws_subnet.subnet-2.id
    tags = {
        Name = "ngw"
    }
}
# Route table-2
resource "aws_route_table" "rt-2" {
    vpc_id = aws_vpc.dev.id

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.nat.id
    }

    tags = {
        Name = "rt-2"
    }
}
# Route table association
resource "aws_route_table_association" "private" {
    subnet_id = aws_subnet.subnet-2.id
    route_table_id = aws_route_table.rt-2.id
}