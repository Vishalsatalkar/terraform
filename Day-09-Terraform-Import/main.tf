resource "aws_instance" "name" {
    ami = "ami-097add592ffeb19c0"
    instance_type = "t3.micro"
    tags = {
      Name = "terraform-import"
    }

}