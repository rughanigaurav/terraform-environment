resource "aws_iam_role" "ssm_role" {

  name = "ssm-role"
  assume_role_policy = <<EOF
  {
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "ssm:*",
      "Resource": "*"
    }
  ]
}
EOF  
}

resource "aws_iam_policy" "ssm_policy" {
  name = "ssm-policy"
  description = "Allow SSM access"

  policy = <<EOF
  {
     "Version": "2012-10-17",
     "Statement": [
      {
        "Effect": "Allow",
        "Action": "ssm:*",
        "Resource": "*"
      }
    ]
  }
EOF
}

resource "aws_iam_role_policy_attachment" "ssm_attachment" {
  
  role = aws_iam_role.ssm_role.name
  policy_arn = aws_iam_policy.ssm_policy.arn

}