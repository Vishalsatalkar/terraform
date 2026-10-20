resource "aws_iam_user" "user" {
  name = var.user_name
  tags = var.tags
}
resource "aws_iam_policy" "policy" {
    name = var.policy_name
    description = "A policy for the IAM user."

    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
            Effect = "Allow"
            Action = ["s3:ListAllMyBuckets"]
            Resource = "*"
        }]
    })
}
resource "aws_iam_user_policy_attachment" "policy_attachment"{
    user = aws_iam_user.user.name
    policy_arn = aws_iam_policy.policy.arn
}
resource "aws_iam_role" "role" {
    name = var.role_name
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
            Effect = "Allow"
            Principal = {
                Service = "ec2.amazonaws.com"
            }
            Action = "sts:AssumeRole"
        }]
    })
    tags = var.tags
}
resource "aws_iam_role_policy_attachment" "role_policy_attachment" {
    role = aws_iam_role.role.name
    policy_arn = aws_iam_policy.policy.arn
}