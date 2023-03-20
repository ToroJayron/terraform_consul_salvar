
resource "aws_vpc" "consul-j-vpc" {
    cidr_block = "10.0.0.0/16"

    tags = {
      Name = "j-vpc"
    }
}
resource "aws_security_group" "j-consul-sg" {
  name = "j-consul-sg"
  vpc_id = aws_vpc.consul-j-vpc.id 
 ingress {
    from_port = 8300
    to_port = 8302
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
 ingress {
    from_port = 8300
    to_port = 8302
    protocol = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 8500
    to_port = 8500
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
      from_port =22
      to_port=22
      protocol="tcp"
      cidr_blocks=["0.0.0.0/0"]
  }
  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }

}
resource "aws_subnet" "consul-j-subnet" {
  count = var.ec2cluster
  vpc_id = aws_vpc.consul-j-vpc.id 
  cidr_block = "10.0.${count.index}.0/24"
  tags = {
      Name = "consul-j-subnet-${count.index}"
  }
}
resource "aws_internet_gateway" "consul-j-igw" {
    vpc_id = aws_vpc.consul-j-vpc.id  
    tags = {
      Name = "consul-j-igw"
    }
}
resource "aws_route_table" "consul-j-rt" {
    vpc_id= aws_vpc.consul-j-vpc.id 
    route{
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.consul-j-igw.id}"
    }
    tags = {
        Name = "consul-j-rt"
    }  
}
resource "aws_route_table_association" "consul-j-rt-a" {
    count = var.ec2cluster
    subnet_id =aws_subnet.consul-j-subnet[count.index].id
    route_table_id="${aws_route_table.consul-j-rt.id}"
}
