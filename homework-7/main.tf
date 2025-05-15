module "vpc" {
  source = "../modules/VPC"

  vpc_config = {
    vpc = {
      cidr_block = "10.0.0.0/16"
      tags       = merge(local.common_tags, { Name = replace(local.name, "rtype", "vpc") })
    }
    igw = {
      tags = merge(local.common_tags, { Name = replace(local.name, "rtype", "igw") })
    }
    public_rt = {
      tags = merge(local.common_tags, { Name = replace(local.name, "rtype", "public-rt") })
    }
    public_subnets = [
      {
        cidr_block        = "10.0.1.0/24"
        availability_zone = "us-east-2a"
        tags              = merge(local.common_tags, { Name = replace(local.name, "rtype", "public-subnet") })
      },
      {
        cidr_block        = "10.0.2.0/24"
        availability_zone = "us-east-2b"
        tags              = merge(local.common_tags, { Name = replace(local.name, "rtype", "public-subnet") })
      },
      {
        cidr_block        = "10.0.3.0/24"
        availability_zone = "us-east-2c"
        tags              = merge(local.common_tags, { Name = replace(local.name, "rtype", "public-subnet") })
      }
    ],
    nat_eip = {
      tags = merge(local.common_tags, { Name = replace(local.name, "rtype", "nat-eip") })
    }
    nat = {
      tags = merge(local.common_tags, { Name = replace(local.name, "rtype", "nat") })
    }
    private_rt = {
      tags = merge(local.common_tags, { Name = replace(local.name, "rtype", "private-rt") })
    }
    private_subnets = [
      {
        cidr_block        = "10.0.4.0/24"
        availability_zone = "us-east-2a"
        tags              = merge(local.common_tags, { Name = replace(local.name, "rtype", "private-subnet") })
      },
      {
        cidr_block        = "10.0.5.0/24"
        availability_zone = "us-east-2b"
        tags              = merge(local.common_tags, { Name = replace(local.name, "rtype", "private-subnet") })
      },
      {
        cidr_block        = "10.0.6.0/24"
        availability_zone = "us-east-2c"
        tags              = merge(local.common_tags, { Name = replace(local.name, "rtype", "private-subnet") })
      }
    ]
  }
}

module "sg_vpc" {
  source = "../modules/SG"

  sg_config = {
    name          = replace(local.name, "rtype", "vpc-sg")
    environment   = local.common_tags.Environment
    description   = "Security group for ${local.name}"
    vpc_id        = module.vpc.vpc_id
    ingress_ports = [22, 80, 443]
    ingress_cidrs = ["10.0.1.0/24"]
    tags          = merge(local.common_tags, { Name = replace(local.name, "rtype", "sg") })
  }
}

# module "instance" {
#   source                 = "../../modules/ec2"
#   ami                    = data.aws_ami.amazon_linux_2023.id
#   instance_type          = "t2.micro"
#   environment            = "dev"
#   vpc_security_group_ids = [module.sg.security_group_id]

# }


# // fetch amazon linux 2023 ami id
# data "aws_ami" "amazon_linux_2023" {
#   most_recent = true
#   owners      = ["amazon"]

#   filter {
#     name   = "name"
#     values = ["al2023-ami-2023.7.*"]
#   }

#   filter {
#     name   = "architecture"
#     values = ["x86_64"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }
# }
