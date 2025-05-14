module "sg" {
  source = "../../modules/sg"

  name          = "dev-instance-sg"
  description   = "Security group for dev instance"
  ingress_ports = [22, 80, 443]
  ingress_cidrs = ["10.0.1.0/24"]
}

module "instance" {
  source                 = "../../modules/ec2"
  ami                    = data.aws_ami.amazon_linux_2023.id
  instance_type          = "t2.micro"
  environment            = "dev"
  vpc_security_group_ids = [module.sg.security_group_id]

}


// fetch amazon linux 2023 ami id
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.7.*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
