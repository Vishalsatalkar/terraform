resource "aws_instance" "name" {
    ami                         = "ami-0493a9ae0eaf18f4c"
    instance_type               = "t3.small"
    user_data                   = file("userdata.sh")
    subnet_id                   = "subnet-09ef347f52ddba662"
    associate_public_ip_address = true

    tags = {
      Name = "my-server"
    }
}