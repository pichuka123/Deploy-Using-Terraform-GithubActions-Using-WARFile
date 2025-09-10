#VPC
resource "aws_vpc" "my_vpc" {
cidr_block = var.vpc_cidr
enable_dns_hostnames = true
instance_tenancy = "default"
tags = {
Name = "my_vpc"
}
}

# 2 no. of SUBNETS
resource "aws_subnet" "subnets" {
count = length(var.subnet_cidr)
vpc_id = aws_vpc.my_vpc.id
cidr_block = var.subnet_cidr[count.index]
availability_zone = data.aws_availability_zones.available.names[count.index]  #  we need names, not ids here and count.index is for looping
map_public_ip_on_launch = true

tags = {
Name = var.subnet_names[count.index]
}
}
# Note: since we need to have subnets in 2 different availability zones, we have to have that data as well in the vpc module, so we need to create another file inside this voc module called data.tf which is below after variables.tf file.


#Internet Gateway
resource "aws_internet_gateway" "igw" {
vpc_id = aws_vpc.my_vpc.id 

tags = {
Name = "My_InternetGateWay"
}
}

#Route Table
resource "aws_route_table" "rt" {
vpc_id = aws_vpc.my_vpc.id

route {
cidr_block = "0.0.0.0/0" #because I want to be public
gateway_id = aws_internet_gateway.igw.id  
}

tags = {
Name = "MyRouteTable"
}
}

#Route Table Association
resource "aws_route_table_association" "rta" {
count = length(var.subnet_cidr) # 2 subnets are going to be associated
subnet_id = aws_subnet.subnets[count.index].id 
route_table_id = aws_route_table.rt.id
}








