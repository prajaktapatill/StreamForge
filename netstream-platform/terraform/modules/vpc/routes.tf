# 1. Public Route Table (Out to Internet Gateway)
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = var.route_anywhere
    gateway_id = aws_internet_gateway.main.id
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-public-rt"
      Type = "Public"
    },
  )
}

# 2. Private Route Table (Out to NAT Gateway)
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = var.route_anywhere
    nat_gateway_id = aws_nat_gateway.main.id
  }
  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-private-rt"
      Type = "Private"
    },
  )
}
# 3. Database Route Table (Isolated: No route out to internet)
resource "aws_route_table" "database" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-database-rt"
      Type = "Database"
    },
  )
}

# 4. Glue everything together via Table Associations
resource "aws_route_table_association" "public" {
  count          = length(var.availability_zones)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "private" {
  count          = length(var.availability_zones)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}
resource "aws_route_table_association" "database" {
  count          = length(var.availability_zones)
  subnet_id      = aws_subnet.database[count.index].id
  route_table_id = aws_route_table.database.id
}
