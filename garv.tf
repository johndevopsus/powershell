provider "aws" {
  profile = var.profile
  region = var.region
}

# creating of key
resource "tls_private_key" "gravitee-key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# PlatformTech_VPC
# vpc_id = vpc-0e410af354beda627

# creating of ssh key on AWS
resource "aws_key_pair" "generated_key" {
  key_name   = var.generated_key_name
  public_key = tls_private_key.gravitee-key.public_key_openssh
  tags = {
    Name = "aws${var.generated_key_name}"
  }
}

resource "local_file" "ssh_key" {
  filename = "${aws_key_pair.generated_key.key_name}.pem"
  content  = tls_private_key.gravitee-key.private_key_pem
  provisioner "local-exec" {
    command = "chmod 400 ./${var.generated_key_name}.pem"
  }
}

resource "aws_instance" "gravitee" {
  ami                    = var.ami
  key_name               = var.generated_key_name
  vpc_security_group_ids = [aws_security_group.gravitee_server.id]
  instance_type          = var.instance-type
  user_data = base64encode(templatefile("${path.module}/remote-userdata.sh", {
  }))

  tags = {
    Name = "${var.ec2_tags}"
  }
  # ebs_block_device {
  #   device_name = "/dev/sdf"
  #   volume_size = 8
  #   volume_type = "st1"
  # }
  depends_on = [aws_key_pair.generated_key]
}

# S3 bucket directory convention???
terraform {
  backend "s3" {
    bucket = var.s3_bucket_name
    key    = "gravitee/backend/terraform.tfstate"
    region = var.region
  }
}
# resource "aws_ebs_volume" "gravitee_vol" {
#   availability_zone = var.availability_zone
#   size              = 50
#   type              = "st1"
#   tags = {
#     Name = "${var.ec2_tags}-volume"
#   }
# }

# resource "aws_volume_attachment" "gravitee_vol_attachement" {
#   device_name = "/dev/sdf"
#   volume_id   = aws_ebs_volume.gravitee_vol.id
#   instance_id = aws_instance.gravitee.id
# }

# resource "aws_ebs_snapshot" "gravitee_vol_snapshot" {
#   volume_id = aws_ebs_volume.gravitee_vol
# }

output "ssh_server" {
  description = "URL of ssh to gravitee server"
  value       = "ssh -i ${var.generated_key_name}.pem ${var.ec2_type}@${aws_instance.gravitee.public_ip}"
}


######################################################



# resource "aws_s3_bucket" "tf-state-bucket" {
#   bucket = var.s3_bucket_name
#   tags = {
#     Name        = "tf-backend-bucket"
#     Environment = "app-dev"
#   }
# }

# resource "aws_iam_user" "s3_backend_user" {
#   name = "tf-backend-user-for-S3-bucket-backend"
# }

# data "aws_iam_policy" "s3_permissions_shi_app_dev_team" {
#   name        = "${aws_s3_bucket.tf-state-bucket.name}-policy"
#   description = "Shi App Dev Team Terraform State Backend Policy"
#   policy      = <<EOT
#   {
#     "Version": "2012-10-17",
#     "Statement": [
#       {
#         "Effect": "Allow",
#         "Action": "s3:ListBucket",
#         "Resource": "arn:aws:s3:::${var.s3_bucket_name}"
#       },
#       {
#         "Effect": "Allow",
#         "Action": ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"],
#         "Resource": "arn:aws:s3:::${var.s3_bucket_name}/projects/gravitee/backend/terraform.tfstate"
#       }
#     ]
#   }
#   EOT
# }

