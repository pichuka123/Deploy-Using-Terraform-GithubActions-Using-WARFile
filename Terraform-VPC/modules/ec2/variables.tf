variable "sg_id" {
description = "Security Group ID for EC2 Instance"
type = string
}

variable "subnets" {
description = "Subnets for EC2"
type = list(string)
}

variable "ec2_names" {
description = "EC2 Names"
type = list(string)
default = ["WebServer1","WebServer2"]
}

variable "key_name" {
    description = ".pem key for EC2 login"
    type = string
}
