provider "aws" {
  profile = var.profile
  region = var.region
}

##************Gravitee Subnet Creation - Start*******************##
variable "vpc_id" {}

data "aws_vpc" "PlatformTech_VPC" {
  id = var.vpc_id
}

# # do not forget to fix the dependencies and refrences on other sources
# resource "aws_subnet" "gravitee_subnet" {
#   vpc_id            = data.aws_vpc.PlatformTech_VPC.id
#   availability_zone = var.availability_zone[0]
#   cidr_block        = var.cidr_blocks[0]
  
#   tags = {
#     Name = "gravitee"
#   }
# }



resource "aws_subnet" "gravitee_subnet" {
  vpc_id            = data.aws_vpc.PlatformTech_VPC.id
  availability_zone = var.availability_zone[0]
  cidr_block        = var.cidr_blocks[0]
  
  tags = {
    Name = "gravitee"
  }
}

resource "aws_subnet" "gravitee_subnet2" {
  vpc_id            = data.aws_vpc.PlatformTech_VPC.id
  availability_zone = var.availability_zone[1]
  cidr_block        = var.cidr_blocks[1]
  
  tags = {
    Name = "gravitee"
  }
}

# resource "aws_vpc_endpoint_subnet_association" "gravitee_ec2" {
#   vpc_endpoint_id = aws_vpc_endpoint.ec2.id
#   subnet_id       = aws_subnet.gravitee_subnet.id
#   tags = {
#     Name = "gravitee"
#   }
# }

##*************Gravitee Subnet Creation - End******************##

# generating key
resource "tls_private_key" "gravitee-key" {
  algorithm = "RSA"
  rsa_bits  = 2048
  depends_on = [aws_subnet.gravitee_subnet]
}
# creating of ssh key on AWS
resource "aws_key_pair" "generated_key" {
  key_name   = var.generated_key_name
  public_key = tls_private_key.gravitee-key.public_key_openssh
  tags = {
    Name = "aws${var.generated_key_name}"
  }
}

# creating of ssh key on local
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
  availability_zone     = var.availability_zone
  subnet_id              = aws_subnet.gravitee_subnet.id
  # subnet_id              = aws_subnet.gravitee_subnet[0].id     ##### ****if subnets created by iteration *****
  instance_type          = var.instance-type
  # root_block_device {
  #   delete_on_termination = var.root_block_delete_on_termination
  # }
  user_data = base64encode(templatefile("${path.module}/remote-userdata.sh", {
  }))

  tags = {
    Name = "${var.ec2_tags}"
  }

  depends_on = [aws_key_pair.generated_key]
}

resource "aws_ebs_volume" "gravitee_vol" {
  availability_zone = var.availability_zone
  size              = 50
  type              = "sda1"
  final_snapshot = true
  lifecycle {
    prevent_destroy = true
  }
  tags = {
    Name = "${var.ec2_tags}-volume"
  }
}

resource "aws_ebs_snapshot" "gravitee_vol_snapshot" {
  volume_id = aws_ebs_volume.gravitee_vol.id
  storage_tier = standard
  lifecycle {
    prevent_destroy = true
  }
  tags = {
    Name = "${var.ec2_tags}-volume-snap"
  }
}

resource "aws_volume_attachment" "gravitee_vol_att" {
  device_name = "/dev/sda"
  volume_id   = aws_ebs_volume.gravitee_vol.id
  instance_id = aws_instance.gravitee.id
}

resource "aws_ebs_snapshot" "gravitee_vol_snapshot" {
  volume_id = aws_ebs_volume.gravitee_vol
  lifecycle {
    delete_on_termination = false
  }
}

# S3 bucket directory convention
terraform {
  backend "s3" {
    bucket = var.s3_bucket_name
    key    = var.s3_backend_key
    region = var.region
  }
}

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
#         "Resource": "arn:aws:s3:::${var.s3_bucket_name}/${var.s3_backend_key}"
#       }
#     ]
#   }
#   EOT
# }

