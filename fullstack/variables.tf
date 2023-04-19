variable "ec2_tags" {
  type    = string
  default = "gravitee"
}

variable "generated_key_name" {
  type    = string
  default = "gravitee-tf-key"
}
variable "ec2_type" {
  type    = string
  default = "ec2-user"
}

variable "ami" {
  type    = string
  default = "ami-06e46074ae430fba6" #need an update latest aws linux Amazon Linux 2023 AMI ami-06e46074ae430fba6
}
variable "secgr-dynamic-ports" {
  default = [22,80,443,8080,8082,8083,8084,8085]
}

variable "instance-type" {
  type    = string
  default = "t2.medium"
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "profile" {
  type    = string
  default = "jfk"     #need an update
}

variable "availability_zone" {
  type    = list
  default = ["us-east-1a","us-east-1b"]
}

variable "cidr_blocks" {
  type    = list
  default = ["10.242.1.0/28", "10.242.1.16/28"]
}

variable "s3_bucket_name" {
  type    = string
  default = "shi-app-dev-team-tfstate-bucket"
}

variable "availability_zone"{
  type    = string
  default = "us-west-1a"
}

variable "root_block_delete_on_termination"{
  type    = string
  default = "false"
}

variable "s3_backend_key"{
  type    = string
  default = "gravitee/backend/terraform.tfstate"
}
