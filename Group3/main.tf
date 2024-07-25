provider aws {
    region = "us-east-2"
}

#create VPC
resource "aws_vpc" "group_3" {
cidr_block = "10.0.0.0/16"

tags = { 
    Name = "group-3"
   }
}

# key pair
resource "aws_key_pair" "deployer" {
  key_name   = "bastion"
  public_key = file("~/.ssh/id_rsa.pub")
}

#Create Subnets(3)
resource "aws_subnet" "public1" {
   vpc_id     = aws_vpc.group_3.id
   cidr_block = "10.0.1.0/24"
   availability_zone = "us-east-2a"
   tags = {
       Name = "public1"
   }
}
resource "aws_subnet" "public2" {
   vpc_id     = aws_vpc.group_3.id
   cidr_block = "10.0.2.0/24"
   availability_zone = "us-east-2b"
   tags = {
       Name = "public2"
   }
}

resource "aws_subnet" "public3" {
   vpc_id     = aws_vpc.group_3.id
   cidr_block = "10.0.3.0/24"
   availability_zone = "us-east-2c"
   tags = {
       Name = "public3"
   }
}

# Create and attach Internet Gateway
resource "aws_internet_gateway" "group_3" {
 vpc_id = aws_vpc.group_3.id
 tags = {
   Name = "group_3"
 }
}

#Create route table
resource "aws_route_table" "group_3" {
 vpc_id = aws_vpc.group_3.id
 route {
   cidr_block = "0.0.0.0/0"
   gateway_id = aws_internet_gateway.group_3.id
 }
 tags = {
   Name = "group_3"
 }
}


#Associate subnets with route table
resource "aws_route_table_association" "a" {
 subnet_id     = aws_subnet.public1.id
 route_table_id = aws_route_table.group_3.id
}
resource "aws_route_table_association" "b" {
 subnet_id     = aws_subnet.public2.id
 route_table_id = aws_route_table.group_3.id
}
resource "aws_route_table_association" "c" {
 subnet_id     = aws_subnet.public3.id
 route_table_id = aws_route_table.group_3.id
}

# Create RDS and connect to WordPress
resource "aws_db_instance" "group_3" {
 allocated_storage   = 20
 engine              = "mysql"
 engine_version      = "8.0"
 instance_class      = "db.t3.micro"
 db_name                = "wordpressdb"
 username            = "admin"
 password            = "admin123"
 parameter_group_name = "default.mysql8.0"
 skip_final_snapshot = true
 vpc_security_group_ids = [aws_security_group.group_3.id]
 db_subnet_group_name = aws_db_subnet_group.group_3.id
}
resource "aws_db_subnet_group" "group_3" {
 name      = "group-3"
subnet_ids = [aws_subnet.public1.id, aws_subnet.public2.id, aws_subnet.public3.id]
 tags = {
 Name = "group-3"
 }
}
























