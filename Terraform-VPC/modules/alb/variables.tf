variable "sg_id" {
description = "SG ID for Application Load Balancer"
type = string
}

variable "subnets" {
description = "Subnets for Application Load Balancer"
type = list(string)
}

variable "vpc_id" {
description = "VPC ID for Target Group"
type = string
}

variable "instances" {
description = "Instance ID for Target Group Attachment"
type = list(string)
}
