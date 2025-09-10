resource "aws_security_group" "sg" {
name = "sg"
description = "Allows HTTP and SSH inbound traffic"
vpc_id = var.vpc_id
# aws_vpc.my_vpc.id - we cannot give like this directly, since VPC is another module and we cannot access another module’s info. Directly from this security group module, so we have to take the output.tf values from that VPC module.

ingress {
description = "HTTP"
from_port = 80
to_port = 80
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}

ingress {
description = "HTTP"
from_port = 8080
to_port = 8080
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}

ingress {
description = "SSH"
from_port = 22
to_port = 22
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}

egress {
from_port = 0
to_port = 0
protocol = "-1"
cidr_blocks = ["0.0.0.0/0"]
}

tags = {
Name = "MySecurityGroup"
}
}

