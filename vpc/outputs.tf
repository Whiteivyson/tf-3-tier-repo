output "vpc_id" {
    value = aws_vpc.vpc.id
}

output "public_sn1_id" {
    value = aws_subnet.public_sn1.id
}

output "public_sn2_id" {
    value = aws_subnet.public_sn2.id
}

output "private_sn1_id" {
    value = aws_subnet.private_sn1.id
}

output "private_sn2_id" {
    value = aws_subnet.private_sn2.id
}