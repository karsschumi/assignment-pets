######################
# Networking outputs##
######################
output "vpc_id" {
 value =  aws_vpc.VPC.id
}

output "public_subnet_ids" {
  value = aws_subnet.publicsubnets.*.id
}

output "private_subnet_ids" {
  value = aws_subnet.privatesubnets.*.id
}

output "igw_id" {
  value = aws_internet_gateway.IGW.id
}

output "eip_id" {
  value = aws_eip.nat.*.id
}

output "natgw_id" {
  value = aws_nat_gateway.natgw.*.id
}

######################
## ECR outputs########
######################
output "ecr_repo_arn" {
  value = aws_ecr_repository.ecrrepo.arn
}

output "ecr_repo_id" {
  value = aws_ecr_repository.ecrrepo.id
}

output "aws_cloudwatch_group_arn" {
    value = aws_cloudwatch_log_group.cwloggroup.arn
  
}