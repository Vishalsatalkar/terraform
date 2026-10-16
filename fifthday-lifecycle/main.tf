resource "aws_instance" "name" {
    ami = "ami-0493a9ae0eaf18f4c"
    instance_type = "t3.small"
    subnet_id = "subnet-09ef347f52ddba662"
    tags = {
      Name = "my-server"
    }
    lifecycle {
        create_before_destroy = true # creates the resource before destroying the old one, useful for resources that cannot be destroyed and recreated at the same time
    }
    lifecycle {
        prevent_destroy = true # prevents the instance from being destroyed, even if the resource is removed from the configuration
    }
    lifecycle {
        ignore_changes = [ami] # won't destroy the instance if ami is changed, ignores AMI changes
    }
}