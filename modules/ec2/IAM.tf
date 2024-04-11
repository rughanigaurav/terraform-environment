resource "aws_iam_role" "ssm_role" {

  name = "ssm-role"
  assume_role_policy = jsonencode(
    {
    version = "2012-10-17",
    "statement" = [  
    {
        "Effect" = "Allow" ,
        "Principal" = {
            "Service" = "*"
        },
        "Action" = "sts:AssumeRole"
    
    }]
  })
}

resource "aws_iam_policy" "ssm_policy" {
  name        = "ssm_policy"
  description = "Policy for SSM access"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Action    = "ssm:*"
        Resource  = "*"
      }
    ]
  })
}

#Policy for AWS_PowerUser
resource "aws_iam_policy" "admin_policy" {
    name = "Admin_policy"
    description = "Policy for Admin_Role"

    policy = jsonencode({
        version = "2012-10-17"
        Statement = [{
            Effect  = "Allow"
            Action  = "*:*"
            Resource= "*"
        }]
    })
}

resource "aws_iam_role_policy_attachment" "ssm_attachment" {
  
  role = aws_iam_role.ssm_role.name
  policy_arn = aws_iam_policy.ssm_policy
 
}

resource "aws_iam_role_policy_attachment" "admin_access" {

    role = aws_iam_role.ssm_role.name
    policy_arn = aws_iam_policy.admin_policy
  
}