variable "env" {
  type    = string
  default = "test"
}

variable "org" {
  type    = string
  default = "betson" #betson
}

variable "region" {
  type    = string
  default = "eucentral"
}

# VPC Variables

variable "cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnets" {
  type = list(object({
    name       = string
    cidr_block = string
    az         = string
    tags       = map(string)
  }))
  default = [{
    name       = "terraform-test-subnet-a"
    cidr_block = "10.0.1.0/24"
    az         = "eu-central-1a"
    tags = {
      "env" = "Test"
    }
  },
  
  {
    name       = "terraform-test-subnet-b"
    cidr_block = "10.0.2.0/24"
    az         = "eu-central-1b"
    tags = {
      "env" = "Test"
    }
  }]
}

variable "private_subnets" {
  type = list(object({
    name       = string
    cidr_block = string
    az         = string
    tags       = map(string)
  }))
  default = [{
    name       = "terraform-test-subnet-c"
    cidr_block = "10.0.3.0/24"
    az         = "eu-central-1a"
    tags = {
      "env" = "Test"
    }
  },
  {    
    name       = "terraform-test-subnet-d"
    cidr_block = "10.0.4.0/24"
    az         = "eu-central-1b"
    tags = {
      "env" = "Test"
    }
  }]
}


# routes

variable "routes_public" {
  type = list(object({
    cidr_block           = string
    gateway_id           = optional(string)
    transit_gateway_id   = optional(string)
    nat_gateway_id       = optional(string)
    network_interface_id = optional(string)
  }))
  default = [
    {
      cidr_block = "10.0.0.0/16"
    }
  ]
}

variable "routes_private" {
  type = list(object({
    cidr_block           = string
    gateway_id           = optional(string)
    transit_gateway_id   = optional(string)
    nat_gateway_id       = optional(string)
    network_interface_id = optional(string)
  }))
  default = [
    {
      cidr_block = "10.0.0.0/16"
    }
  ]
}


#### Security Groups

variable "ingress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
        {
      from_port   = 3000
      to_port     = 3000
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}
