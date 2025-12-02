# data "aws_iam_policy_document" "ec2_assume_role" {
#   statement {
#     actions = ["sts:AssumeRole"]
#     principals {
#       type        = "Service"
#       identifiers = ["ec2.amazonaws.com"]
#     }
#   }
# }

# resource "aws_iam_role" "ec2_ecr" {
#   name = "${var.environment}-ec2-ecr-role"

#   assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json

#   tags = {
#     Name = "${var.environment}-ec2-ecr-role"
#   }
# }

# resource "aws_iam_role_policy_attachment" "ecr_pull" {
#   role       = aws_iam_role.ec2_ecr.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPullOnly"
# }

# resource "aws_iam_instance_profile" "ec2_ecr" {
#   name = "${var.environment}-ec2-ecr-profile"
#   role = aws_iam_role.ec2_ecr.name

#   tags = {
#     Name = "${var.environment}-ec2-ecr-profile"
#   }
# }
