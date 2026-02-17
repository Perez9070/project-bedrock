resource "aws_iam_user" "bedrock_dev_view" {
  name = "bedrock-dev-view"
  tags = {
    Project = "Bedrock"
  }
}

resource "aws_iam_user_policy_attachment" "bedrock_readonly" {
  user       = aws_iam_user.bedrock_dev_view.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_access_key" "bedrock_dev_key" {
  user       = aws_iam_user.bedrock_dev_view.name
  depends_on = [aws_iam_user_policy_attachment.bedrock_readonly]
}

# Provide console login (password will be user-visible in outputs for grading). Password_reset_required is true.
resource "aws_iam_user_login_profile" "bedrock_dev_console" {
  user                    = aws_iam_user.bedrock_dev_view.name
  password_length         = 16
  password_reset_required = true
}