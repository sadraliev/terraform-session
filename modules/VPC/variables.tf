variable "vpc_config" {
  description = "The configuration for the VPC"
  type = object({
    vpc = object({
      cidr_block = string
      tags       = optional(map(string))
    })
    igw = object({
      tags = optional(map(string))
    })
    public_rt = object({
      tags = optional(map(string))
    })
    public_subnets = list(object({
      cidr_block        = string
      availability_zone = string
      tags              = optional(map(string))
    }))
    nat_eip = object({
      tags = optional(map(string))
    })
    nat = object({
      tags = optional(map(string))
    })
    private_rt = object({
      tags = optional(map(string))
    })
    private_subnets = list(object({
      cidr_block        = string
      availability_zone = string
      tags              = optional(map(string))
    }))
  })

}
