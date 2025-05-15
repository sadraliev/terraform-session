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
    description   = "Allow SSH, HTTP and HTTPS traffic"
    vpc_id        = module.vpc.vpc_id
    ingress_ports = [80, 443]
    ingress_cidrs = ["0.0.0.0/0"]
    tags          = merge(local.common_tags, { Name = replace(local.name, "rtype", "sg") })
  }
}

module "sg_alb" {
  source = "../modules/SG"

  sg_config = {
    name          = replace(local.name, "rtype", "alb-sg")
    environment   = local.common_tags.Environment
    description   = "Allow HTTP and HTTPS traffic"
    vpc_id        = module.vpc.vpc_id
    ingress_ports = [80, 443]
    ingress_cidrs = ["0.0.0.0/0"]
    tags          = merge(local.common_tags, { Name = replace(local.name, "rtype", "sg") })
  }
}

module "sg_ec2" {
  source = "../modules/SG"

  sg_config = {
    name          = replace(local.name, "rtype", "ec2-sg")
    environment   = local.common_tags.Environment
    description   = "Allow HTTP traffic from ALB"
    vpc_id        = module.vpc.vpc_id
    ingress_ports = [80]
    ingress_cidrs = ["0.0.0.0/0"]
    tags          = merge(local.common_tags, { Name = replace(local.name, "rtype", "sg") })
  }
}
module "alb" {
  source = "../modules/ALB"
  alb_config = {
    alb = {
      name               = replace(local.name, "rtype", "alb")
      internal           = false
      load_balancer_type = "application"
      subnets            = module.vpc.public_subnet_ids
      security_groups    = [module.sg_alb.security_group_id]
    }
    target_group = {
      name     = replace(local.name, "rtype", "alb-tg")
      port     = 80
      protocol = "HTTP"
      vpc_id   = module.vpc.vpc_id
      health_check = {
        path                = "/"
        interval            = 30
        timeout             = 10
        healthy_threshold   = 2
        unhealthy_threshold = 2
      }
    }
    listener = {
      port     = 80
      protocol = "HTTP"
    }
  }
}
module "asg" {
  source = "../modules/ASG"
  asg_config = {
    launch_template = {
      name_prefix   = "app"
      image_id      = data.aws_ami.amazon_linux_2023.id
      instance_type = "t2.micro"
      network_interfaces = {
        security_groups             = [module.sg_ec2.security_group_id]
        associate_public_ip_address = false
        subnet_id                   = module.vpc.private_subnet_ids[0]
      }
      user_data = file("user-data.sh")
    }
    asg = {
      name                = replace(local.name, "rtype", "asg")
      vpc_zone_identifier = module.vpc.private_subnet_ids
      target_group_arns   = [module.alb.target_group_arn]
      desired_capacity    = 2
      max_size            = 3
      min_size            = 1
    }
  }
}

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
