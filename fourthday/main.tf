resource "aws_instance" "name" {
    ami = "ami-0493a9ae0eaf18f4c"
    instance_type = "t3.small"
    subnet_id = "subnet-09ef347f52ddba662"
    tags = {
      Name = "my-server"
    }
}
