#Creating Provider for AWS 
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "ArtifactoriesTERRAFORM" {
    ami = "ami-0e449927258d45bc4"
    instance_type =  "t2.micro"
    key_name = "ArtifactoriesTERRAFORMKP"
    //security_groups =  [ "TerraformSecurityGroup" ]
    vpc_security_group_ids = [aws_security_group.TerraformSecurityGroup.id]
    subnet_id = aws_subnet.TerraformSubnet01.id
}

resource "aws_security_group" "TerraformSecurityGroup" {
  name        = "TerraformSecurityGroup"
  description = "Security Group for Terraform Use Case w.r.to SSH Access"
  vpc_id     = aws_vpc.TerraformVPC.id

  ingress {
    description      = "Allow SSH Access"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"] #Accessing from Outside Network (Internet)
  }

  ingress {
    description      =  "Allow HTTP Access"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    description      = "Allow all outbound traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "TerraformSSH"
  }
}

resource "aws_vpc" "TerraformVPC" {
  cidr_block = "10.1.0.0/16"
  tags = {
    Name = "TerraformVPC"
  }
}

resource "aws_subnet" "TerraformSubnet01" {
  vpc_id            = aws_vpc.TerraformVPC.id
  cidr_block        = "10.1.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"
    tags = {
        Name = "TerraformSubnet01"
    }
}

resource "aws_subnet" "TerraformSubnet02" {
  vpc_id            = aws_vpc.TerraformVPC.id
  cidr_block        = "10.1.2.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"
    tags = {
        Name = "TerraformSubnet02"
    }
}

resource "aws_internet_gateway" "TerraformIGW" {
  vpc_id = aws_vpc.TerraformVPC.id
  tags = {
    Name = "TerraformIGW"
  }
}

resource "aws_route_table" "TerraformRouteTable" {
  vpc_id = aws_vpc.TerraformVPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.TerraformIGW.id   
    }
}
  
resource "aws_route_table_association" "TerraformRouteTableAssociation01" {
  subnet_id      = aws_subnet.TerraformSubnet01.id
  route_table_id = aws_route_table.TerraformRouteTable.id
}   

resource "aws_route_table_association" "TerraformRouteTableAssociation02" {
  subnet_id      = aws_subnet.TerraformSubnet02.id
  route_table_id = aws_route_table.TerraformRouteTable.id
}