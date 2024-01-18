resource "aws_iam_role" "ec2_role" {
  name = "EC2_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = ["ec2.amazonaws.com", "ecs-tasks.amazonaws.com"]
        }
      },
    ]
  })
}
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_profile_k8s"
  role = aws_iam_role.ec2_role.name
}
