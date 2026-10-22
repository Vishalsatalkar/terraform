module "network" {
    source = "./modules/network"
    vpc_cidr = "10.0.0.0/16"
    subnet_cidr = "10.0.0.0/24"
}
module "compute" {
    source = "./modules/compute"
    ami = "ami-0493a9ae0eaf18f4c"
    instance_type = "t3.small"
    subnet_id = module.network.subnet_id
}