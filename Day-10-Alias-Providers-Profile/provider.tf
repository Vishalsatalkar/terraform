provider "aws" {
  region = "eu-north-1"
}
provider "aws" {
  alias = "dev"
  region = "us-west-2"
}