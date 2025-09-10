# IAM Role
resource "aws_iam_role" "ec2_role" {
  name = "ec2-s3-access-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# IAM Policy for S3 Read
resource "aws_iam_policy" "s3_read_policy" {
  name        = "ec2-s3-read-policy"
  description = "Allow EC2 to read from S3"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = ["s3:GetObject"],
        Resource = "arn:aws:s3:::pichukaartifactbucket/*"
      }
    ]
  })
}

# Attach policy to role
resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.s3_read_policy.arn
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-s3-access-profile"
  role = aws_iam_role.ec2_role.name
}

# EC2 Instance Profile
resource "aws_instance" "web" {
count = length(var.ec2_names)
ami = data.aws_ami.amazon-2.id
instance_type = "t2.micro"
key_name =  var.key_name
associate_public_ip_address = true
vpc_security_group_ids = [var.sg_id]
subnet_id = var.subnets[count.index]
availability_zone = data.aws_availability_zones.available.names[count.index]
user_data = base64encode(file("${path.module}/userdata.sh"))
iam_instance_profile = aws_iam_instance_profile.ec2_profile.name


tags = {
Name = var.ec2_names[count.index]
}

}
