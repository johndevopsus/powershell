resource "aws_security_group" "gravitee_server" {
  name        = "gravitee-server-sg"
  description = "Allow SSH/TLS inbound traffic"

  dynamic "ingress" {
    for_each = var.secgr-dynamic-ports
    content {
      from_port = ingress.value
      to_port = ingress.value
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
}

  egress {
    description = "Outbound Allowed"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "gravitee-server-sg"
  }
}

# if we need to define cidr_blocks differenlty, we can use the below block
# resource "aws_security_group" "gravitee_server" {
#   name = "gravitee-server-sg"
#   #description = "Allow TLS inbound traffic".
#   vpc_id = aws_vpc.gravitee-vpc.id

#   ingress = [
#     {
#       description       = "for ssh"
#       from_port         = 22
#       to_port           = 22
#       protocol          = "tcp"
#       cidr_blocks       = ["0.0.0.0/0"]
#       ipv6_cidr_blocks  = ["::/0"]
#       prefix_list_ids   = null
#       security_groups   = null
#       self              = null
#       security_group_id = aws_security_group.gravitee_server.id
#     },
#     {
#       description      = "for MongoDB"
#       from_port        = 27017
#       to_port          = 27017
#       protocol         = "tcp"
#       cidr_blocks      = ["0.0.0.0/0"]
#       ipv6_cidr_blocks = ["::/0"]
#       prefix_list_ids  = null
#       security_groups  = null
#       self             = null
#       security_group_id = aws_security_group.gravitee_server.id
#     },
#     {
#       description      = "for Elasticsearch"
#       from_port        = 9200
#       to_port          = 9200
#       protocol         = "tcp"
#       cidr_blocks      = ["0.0.0.0/0"]
#       ipv6_cidr_blocks = ["::/0"]
#       prefix_list_ids  = null
#       security_groups  = null
#       self             = null
#       security_group_id = aws_security_group.gravitee_server.id
#     },
#     {
#       description      = "for http"
#       from_port        = 80
#       to_port          = 80
#       protocol         = "tcp"
#       cidr_blocks      = ["0.0.0.0/0"]
#       ipv6_cidr_blocks = ["::/0"]
#       prefix_list_ids  = null
#       security_groups  = null
#       self             = null
#       security_group_id = aws_security_group.gravitee_server.id
#     },
#     {
#       description       = "for https"
#       from_port         = 8080
#       to_port           = 8080
#       protocol          = "tcp"
#       cidr_blocks       = ["0.0.0.0/0"]
#       ipv6_cidr_blocks  = ["::/0"]
#       prefix_list_ids   = null
#       security_groups   = null
#       self              = null
#       security_group_id = aws_security_group.gravitee_server.id
#     },
#     {
#       description       = "for gravitee Gateway"
#       from_port         = 8082
#       to_port           = 8082
#       protocol          = "tcp"
#       cidr_blocks       = ["0.0.0.0/0"]
#       ipv6_cidr_blocks  = ["::/0"]
#       prefix_list_ids   = null
#       security_groups   = null
#       self              = null
#       security_group_id = aws_security_group.gravitee_server.id
#     },
#     {
#       description       = "for gravitee REST API"
#       from_port         = 8083
#       to_port           = 8083
#       protocol          = "tcp"
#       cidr_blocks       = ["0.0.0.0/0"]
#       ipv6_cidr_blocks  = ["::/0"]
#       prefix_list_ids   = null
#       security_groups   = null
#       self              = null
#       security_group_id = aws_security_group.gravitee_server.id
#     },

#     {
#       description       = "for gravitee Management UI"
#       from_port         = 8084
#       to_port           = 8084
#       protocol          = "tcp"
#       cidr_blocks       = ["0.0.0.0/0"]
#       ipv6_cidr_blocks  = ["::/0"]
#       prefix_list_ids   = null
#       security_groups   = null
#       self              = null
#       security_group_id = aws_security_group.gravitee_server.id
#     },
#     {
#       description       = "for gravitee Portal UI"
#       from_port         = 8085
#       to_port           = 8085
#       protocol          = "tcp"
#       cidr_blocks       = ["0.0.0.0/0"]
#       ipv6_cidr_blocks  = ["::/0"]
#       prefix_list_ids   = null
#       security_groups   = null
#       self              = null
#       security_group_id = aws_security_group.gravitee_server.id
#     },

#   ]
#   egress = [
#     {
#       description      = "allow all"
#       from_port        = 0
#       to_port          = 0
#       protocol         = "-1"
#       cidr_blocks      = ["0.0.0.0/0"]
#       ipv6_cidr_blocks = ["::/0"]
#       prefix_list_ids  = null
#       security_groups  = null
#       self             = null
#     }
#   ]

#   tags = {
#     Name = "gravitee-server-sg"
#   }
# }
