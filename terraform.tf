provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "instancekey" {
  key_name   = "emekakey"
  public_key = file("${path.module}/emekakey.pub")
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"

  tags = {
    Name = "public_subnet"
  }
  
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Ig-Gate-Way"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

}

resource "aws_route_table_association" "public_1" {
  subnet_id = aws_subnet.public.id
  route_table_id = aws_route_table.public_rt.id
  
}

resource "aws_security_group" "example_sg" {
  name        = "example_sg"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP from VPC"
    from_port = 5000
    to_port = 5000
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  
  ingress {
    description = "ssh"
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
  
}

resource "aws_instance" "myec2vm" {
  ami = "ami-00a929b66ed6e0de6"
  key_name = aws_key_pair.instancekey.key_name
  instance_type = "t2.micro"
  subnet_id = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.example_sg.id]
  associate_public_ip_address = true

  depends_on = [
    aws_route_table_association.public_1
  ]

  tags = {
    "Name" = "EC2 Dem0"
  }

  connection {
   type = "ssh"
   user = "ec2-user"
   private_key =  file("${path.module}/emekakey")
   host = self.public_ip
   timeout = "2m"
   
  
  }

  provisioner "file" {
    source = "ani.py"
    destination = "/home/ec2-user/ani.py"
  }
  
  provisioner "remote-exec" {
  inline = [
    "echo 'Hello from the EC2 instance'",
    "sudo yum update -y",
    "sudo yum install -y python3-pip",
    "cd /home/ec2-user",
    "pip3 install flask",
    "nohup python3 ani.py > output.log 2>&1 &"
  ]
 }

}

output "instance_public_ip" {
  value = aws_instance.myec2vm.public_ip
}






     






