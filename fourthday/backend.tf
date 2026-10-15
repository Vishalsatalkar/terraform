terraform {
  backend "s3" {
    bucket         = "vishal-1234-windows"
    key            = "dev/terraform.tfstate"
    region         = "eu-north-1"
    encrypt        = true
    # dynamodb_table = "terraform-state-locks"
    use_lockfile   = true
  }
}