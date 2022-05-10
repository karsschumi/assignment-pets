####################
# Common variables #
####################
variable "resource_name_prefix"{
    description = "Name prefix to be used for all the resources"
}


####################
# ECR variables #
####################
variable "tag_mutability"{
    description = "The tag mutability setting for the repository. Must be"
    default = "MUTABLE"
}

variable "image_scan_on_push"{
    description = "Indicates whether images are scanned after being pushed to the repository (true) or not scanned (false)."
    default = true
}


########################
# Networking variables #
########################
variable "vpc_cidr_block"{
    description = "The IPv4 CIDR block for the VPC"
}

variable "private_subnet_cidr"{
    description = "The IPv4 CIDR block for the private Subnets"
    type = list
}

variable "public_subnet_cidr"{
    description = "The IPv4 CIDR block for the public Subnets"
        type = list
}

variable "availability_zones"{
    description = "AZ for the subnet."
    type = list
}