#provider
provider "aws" {
   region = "us-east-1"
}

#vpc
resource "aws_vpc" "my_vpc" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Name = "tf-example-vpc"
  }
}

# subnet
resource "aws_subnet" "my_subnet" {
  vpc_id            = "${aws_vpc.my_vpc.id}"
  cidr_block        = "172.16.10.0/24"
  availability_zone = "us-east-1a"
#  map_public_ip_on_launch = "true"

  tags = {
    Name = "tf-public-subnet"
  }
}


# Define the internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.my_vpc.id}"

  tags {
    Name = "VPC IGW"
  }
}

# Define the route table
resource "aws_route_table" "web-public-rt" {
  vpc_id = "${aws_vpc.my_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags {
    Name = "Public Subnet RT"
  }
}

# Assign the route table to the public Subnet
resource "aws_route_table_association" "web-public-rt" {
  subnet_id = "${aws_subnet.my_subnet.id}"
  route_table_id = "${aws_route_table.web-public-rt.id}"
}

# ec2-key-pair and local system pub key
resource "aws_key_pair" "terraform-ex" {
   key_name = "terraform-ex"
   public_key = "${file("/Users/vynu/.ssh/id_rsa.pub")}"
}

# network interface
#resource "aws_network_interface" "foo" {
#  subnet_id   = "${aws_subnet.my_subnet.id}"
#  private_ips = ["172.16.10.100"]
#  security_groups = ["${aws_security_group.ssh_jenkins.name}"]
#
#  tags = {
#    Name = "primary_network_interface"
#  }
#}

#security groups
resource "aws_security_group" "ssh_jenkins" {
  name        = "allow-ssh-jenkins"
  description = "Allow ssh,jenkins inbound traffic"
  vpc_id      = "${aws_vpc.my_vpc.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    description = "ssh"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    description = "jenkins"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8500
    to_port     = 8500
    protocol    = "tcp"
    description = "consul"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "allow-ssh-jenkins"
  }
}


# EC2 instance
resource "aws_instance" "foo" {
  ami           = "ami-035be7bafff33b6b6" # us-east-1
  instance_type = "t2.micro"

  depends_on = [
                 "aws_security_group.ssh_jenkins",
                 "aws_iam_instance_profile.test_profile",
                 "aws_vpc.my_vpc",
                 "aws_subnet.my_subnet",
                 "aws_security_group.ssh_jenkins"
               ]
  key_name = "terraform-ex"
  associate_public_ip_address = "true"
  subnet_id = "${aws_subnet.my_subnet.id}"
  vpc_security_group_ids = ["${aws_security_group.ssh_jenkins.id}"]
  user_data = "${file("boot-strap.sh")}"
  iam_instance_profile = "${aws_iam_instance_profile.test_profile.name}"

#  network_interface {
#    network_interface_id = "${aws_network_interface.foo.id}"
#    device_index         = 0
#  }
  
  tags = {
    Name = "terraform-jenkins"
  }

}
