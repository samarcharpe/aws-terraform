# We are using AWS Cloud


provider "aws" {
  region  = "${var.region}"
}

#define variables

# The AWS region.
variable "region" {
  default = "ap-south-1"
  description = "The region to install the resources"	
}

# The vpc CIDR
variable "vpc_cidr" {
  default = "10.1.0.0/16"
  description = "The region to install the resources"
}



#create vpc with required specs

resource "aws_vpc" "samar-vpc-terraform" {
  cidr_block = "${var.vpc_cidr}"
  
  tags = {
    Name = "samar-vpc-terraform"
  }
}


#create internet gateway
resource "aws_internet_gateway" "samar-igw" {
  vpc_id = "${aws_vpc.samar-vpc-terraform.id}"

  tags = {
    Name = "samar-igw"
  }
}


#create route table for private subnets

resource "aws_route_table" "samar-private-routetable" {
  vpc_id = "${aws_vpc.samar-vpc-terraform.id}"

  tags = {
    Name = "samar-private-routetable"
  }
}

	
#create route tabe for public subnets

resource "aws_route_table" "samar-public-routetable" {
  vpc_id = "${aws_vpc.samar-vpc-terraform.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.samar-igw.id}"
  }

  tags = {
    Name = "samar-public-routetable"
  }
}


#create private subnets with required specs in each AZ

resource "aws_subnet" "samar-subnet-terraform-private-a" {
  vpc_id     = aws_vpc.samar-vpc-terraform.id
  cidr_block = "10.1.1.0/24"
  availability_zone = "${var.region}a"
  tags = {
    Name = "samar-subnet-terraform-private-a"
  }
}

resource "aws_subnet" "samar-subnet-terraform-private-b" {
  vpc_id     = aws_vpc.samar-vpc-terraform.id
  cidr_block = "10.1.2.0/24"
  availability_zone = "${var.region}b"
  tags = {
    Name = "samar-subnet-terraform-private-b"
  }
}

resource "aws_subnet" "samar-subnet-terraform-private-c" {
  vpc_id     = aws_vpc.samar-vpc-terraform.id
  cidr_block = "10.1.3.0/24"
  availability_zone = "${var.region}c"
  tags = {
    Name = "samar-subnet-terraform-private-c"
  }
}

#create Public subnets with required specs in each AZ

resource "aws_subnet" "samar-subnet-terraform-public-a" {
  vpc_id     = aws_vpc.samar-vpc-terraform.id
  cidr_block = "10.1.10.0/24"
  availability_zone = "${var.region}a"
  tags = {
    Name = "samar-subnet-terraform-public-a"
  }
}

resource "aws_subnet" "samar-subnet-terraform-public-b" {
  vpc_id     = aws_vpc.samar-vpc-terraform.id
  cidr_block = "10.1.20.0/24"
  availability_zone = "${var.region}b"
  tags = {
    Name = "samar-subnet-terraform-public-b"
  }
}

resource "aws_subnet" "samar-subnet-terraform-public-c" {
  vpc_id     = aws_vpc.samar-vpc-terraform.id
  cidr_block = "10.1.30.0/24"
  availability_zone = "${var.region}c"
  tags = {
    Name = "samar-subnet-terraform-public-c"
  }
}

#create route table associations for our private subnets


resource "aws_route_table_association" "samar-subnet-terraform-private-a-rt-asso" {
  subnet_id      = "${aws_subnet.samar-subnet-terraform-private-a.id}"
  route_table_id =  "${aws_route_table.samar-private-routetable.id}"
}
resource "aws_route_table_association" "samar-subnet-terraform-private-b-rt-asso" {
  subnet_id      = "${aws_subnet.samar-subnet-terraform-private-b.id}"
  route_table_id = "${aws_route_table.samar-private-routetable.id}"
}
resource "aws_route_table_association" "samar-subnet-terraform-private-c-rt-asso" {
  subnet_id      = "${aws_subnet.samar-subnet-terraform-private-c.id}"
  route_table_id = "${aws_route_table.samar-private-routetable.id}"
}


#create route table associations for our Public subnets

resource "aws_route_table_association" "samar-subnet-terraform-public-a-rt-asso" {
  subnet_id      = "${aws_subnet.samar-subnet-terraform-public-a.id}"
  route_table_id = "${aws_route_table.samar-public-routetable.id}"
}
resource "aws_route_table_association" "samar-subnet-terraform-public-b-rt-asso" {
  subnet_id      = "${aws_subnet.samar-subnet-terraform-public-b.id}"
  route_table_id ="${aws_route_table.samar-public-routetable.id}"
}
resource "aws_route_table_association" "samar-subnet-terraform-public-c-rt-asso" {
  subnet_id      = "${aws_subnet.samar-subnet-terraform-public-c.id}"
  route_table_id = "${aws_route_table.samar-public-routetable.id}"
}

# define security groups

resource "aws_security_group" "samar_sg_22" {
  name = "samar_sg_22"
  vpc_id = "${aws_vpc.samar-vpc-terraform.id}"
}
  # SSH access from the world
  
resource "aws_security_group_rule"  "samar_allow_ssh_ingress" {
	type = "ingress"
    from_port   = 0
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
	security_group_id = "${aws_security_group.samar_sg_22.id}"
  }

resource "aws_security_group_rule"  "samar_allow_ssh_egress" {
	type = "egress"
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
	security_group_id = "${aws_security_group.samar_sg_22.id}"
  }

resource "aws_security_group" "samar_sg_80" {
  name = "samar_sg_80"
  vpc_id = "${aws_vpc.samar-vpc-terraform.id}"
}
  # http access from the world
  
resource "aws_security_group_rule"  "samar_allow_http_ingress" {
	type = "ingress"
    from_port   = 0
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
	security_group_id = "${aws_security_group.samar_sg_80.id}"
  }

resource "aws_security_group_rule"  "samar_allow_http_egress" {
	type = "egress"
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
	security_group_id = "${aws_security_group.samar_sg_80.id}"
  }


resource "aws_security_group" "samar_sg_443" {
  name = "samar_sg_443"
  vpc_id = "${aws_vpc.samar-vpc-terraform.id}"
}
  # http access from the world
  
resource "aws_security_group_rule"  "samar_allow_https_ingress" {
	type = "ingress"
    from_port   = 0
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
	security_group_id = "${aws_security_group.samar_sg_443.id}"
  }

resource "aws_security_group_rule"  "samar_allow_https_egress" {
	type = "egress"
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
	security_group_id = "${aws_security_group.samar_sg_443.id}"
  }

#create AWS EC2 instance 

resource "aws_instance" "samar_rhel_web" {
  ami           = "ami-0a74bfeb190bd404f"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.samar-subnet-terraform-public-a.id}"
  vpc_security_group_ids = ["${aws_security_group.samar_sg_80.id}" , "${aws_security_group.samar_sg_22.id}"  , "${aws_security_group.samar_sg_443.id}"]
  key_name = "samar-ap-south-keypair"
  associate_public_ip_address = true
  tags = {
    Name = "samar_rhel_web"
  }
}



#get outputs

output "my_instance_name" {
  value = aws_instance.samar_rhel_web.id
}

output "my_instance_pubicip" {
  value = aws_instance.samar_rhel_web.public_ip
}

