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

tags = {
Name = var.ec2_names[count.index]
}

}
