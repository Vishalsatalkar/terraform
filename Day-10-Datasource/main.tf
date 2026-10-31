data "aws_subnet" "name" {
    id = "subnet-09ef347f52ddba662"
}

resource "aws_instance" "name" {
    ami                         = "ami-0493a9ae0eaf18f4c"
    instance_type               = "t3.small"
    subnet_id                   = data.aws_subnet.name.id
    associate_public_ip_address = true

    tags = {
      Name = "my-server"
    }
}