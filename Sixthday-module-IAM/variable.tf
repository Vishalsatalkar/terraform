variable "user_name" {
  description = "The name of the IAM user to create."
  type        = string
  default     = "dev-user"
}
variable "role_name" {
    description = "The name of the IAM role to create."
    type        = string
    default     = "dev-role"
}
variable "policy_name" {
    description = "The name of the IAM policy to create"
    type        = string
    default     = "dev-policy"
}
variable "tags" {
    description = "A map of tags to assign to the IAM resources."
    type        = map(string)
    default     = {
        Environment = "dev"
        ManagedBy     = "terraform"
    }
}