variable "nit" {
  type = list(string)
  default = ["dev", "prod"]
}
resource "aws_instance" "name" {
    ami = "ami-0493a9ae0eaf18f4c"
    instance_type = "t3.small"
    subnet_id = "subnet-09ef347f52ddba662"
    for_each=toset(var.nit)
    tags = {
        Name = each.key
    }  
}