#######
# VPC #
#######
resource "aws_vpc" "VPC" {
  cidr_block = var.vpc_cidr_block
}

################################################
# Create Internet Gateway and attach it to VPC #
################################################
 resource "aws_internet_gateway" "IGW" {   
    vpc_id =  aws_vpc.VPC.id              
 }

#############################
 # Create a Public Subnets. #
#############################
 resource "aws_subnet" "publicsubnets" {   
   count=length(var.public_subnet_cidr)

   vpc_id =  aws_vpc.VPC.id
   cidr_block = var.public_subnet_cidr[count.index]
   availability_zone = element(var.availability_zones,count.index)
 }

 ############################
 # Creating Private Subnets #
 ############################
 resource "aws_subnet" "privatesubnets" {
   count=length(var.private_subnet_cidr)
   
   vpc_id =  aws_vpc.VPC.id
   cidr_block = var.private_subnet_cidr[count.index]
   availability_zone = element(var.availability_zones,count.index)
 }

 #################################
 # Route table for Public Subnet's #
 #################################
 resource "aws_route_table" "PublicRT" {    # Creating RT for Public Subnet
    vpc_id =  aws_vpc.VPC.id
         route {
    cidr_block = "0.0.0.0/0"               # Traffic from Public Subnet reaches Internet via Internet Gateway
    gateway_id = aws_internet_gateway.IGW.id
     }
 }

 #################################
 # Route table for Private Subnet's #
 #################################
 resource "aws_route_table" "PrivateRT" {
  count = length(var.private_subnet_cidr)

   vpc_id = aws_vpc.VPC.id
 }

 ##############################################
 # Route table Association with Public Subnet's #
 ##############################################
 resource "aws_route_table_association" "PublicRTassociation" {
    count=length(var.public_subnet_cidr)

    subnet_id = element(aws_subnet.publicsubnets.*.id,count.index)
    route_table_id = aws_route_table.PublicRT.id
 }

 ##############################################
 # Route table Association with Private Subnet's #
 ##############################################
 resource "aws_route_table_association" "PrivateRTassociation" {
     count=length(var.private_subnet_cidr)

    subnet_id = element(aws_subnet.privatesubnets.*.id,count.index)
    route_table_id = element(aws_route_table.PrivateRT.*.id,count.index)
 }

 ##################################
 # EIP for NAT Gateways#
 #######################

 resource "aws_eip" "nat" {
 count = length(var.private_subnet_cidr)

 vpc = true
 }

 ################
 # NAT Gateways #
 ################

 resource "aws_nat_gateway" "natgw" {
   count = length(var.private_subnet_cidr)
   
   allocation_id = element(aws_eip.nat.*.id,count.index)
   subnet_id = element(aws_subnet.publicsubnets.*.id,count.index)
 
  depends_on = [
    aws_internet_gateway.IGW
  ]
 
 }
 ##################
 # Private Routes #
 ##################

 resource "aws_route" "private_ngw_route" {
   count = length(var.private_subnet_cidr) 
   
   nat_gateway_id = element(aws_nat_gateway.natgw.*.id,count.index)
   route_table_id = element(aws_route_table.PrivateRT.*.id, count.index)
   destination_cidr_block = "0.0.0.0/0"
 }