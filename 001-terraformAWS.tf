#Creating Provider for AWS 
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "ArtifactoriesTERRAFORM" {
    ami = "ami-0e449927258d45bc4"
    instance_type =  "t2.micro"
    key_name = "ArtifactoriesTERRAFORMKP"
}