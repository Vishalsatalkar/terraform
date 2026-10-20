module "dev" {
    source = "../Sixthday-terraform-modules"
    ami = "ami-0493a9ae0eaf18f4c"
    subnet_id = "subnet-09ef347f52ddba662"  
}