module "iam_dev" {
    source = "../Sixthday-module-IAM"

    user_name = "Vishal-IAM-User"
    role_name = "Vishal-IAM-Role"
    policy_name = "Vishal-IAM-Policy"

    tags = {
        Environment = "dev"
        owner = "Vishal"
    }
}