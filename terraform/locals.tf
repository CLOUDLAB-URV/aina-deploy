locals {
  vpc_id = aws_vpc.main.id

  subnet_cidr = cidrsubnet(var.vpc_cidr, var.subnet_newbits, var.subnet_index)

  subnet_id = aws_subnet.main.id

  all_sg_ids = concat(
    [aws_security_group.ssh.id, aws_security_group.app.id],
    var.additional_sg_ids
  )
}
