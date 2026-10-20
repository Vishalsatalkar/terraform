variable "ami" {
  description = "The AMI ID to use for the EC2 instance"
  type        = string
  default     = "ami-0493a9ae0eaf18f4c"
}
variable "instance_type" {
    description = "The instance type to use for the EC2 instance"
    type        = string
    default     = "t3.small"  
}
variable "subnet_id" {
    description = "The Subnet ID to launch the ec2 instance"
    type        = string
    default     = "subnet-09ef347f52ddba662"
}
variable "tags" {
    description = "A map of tags to assign to the resource"
    type        = map(string)
    default     = {
        Name = "my-server"
    }
}