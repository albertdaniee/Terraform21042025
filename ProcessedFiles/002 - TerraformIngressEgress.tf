#Creating Provider for AWS 
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "ArtifactoriesTERRAFORM" {
    ami = "ami-0e449927258d45bc4"
    instance_type =  "t2.micro"
    key_name = "ArtifactoriesTERRAFORMKP"
    security_groups =  [ "TerraformSecurityGroup" ]
}

resource "aws_security_group" "TerraformSecurityGroup" {
  name        = "TerraformSecurityGroup"
  description = "Security Group for Terraform Use Case w.r.to SSH Access"

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
