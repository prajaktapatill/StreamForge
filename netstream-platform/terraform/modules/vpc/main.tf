# 1. Core VPC
resource "aws_vpc" "this" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    var.tags,
    {
        Name = "${var.project_name}-${var.environment}-vpc"
        Type = "Core"
    },
  )
}   
# 2. Public Subnets (Slots 1, 2, 3)
resource "aws_subnet" "public" {
  count                   = length(var.availability_zones)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = cidrsubnet(var.cidr_block, 8, count.index + 1)
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    var.tags,
    {
        Type = "Public"
        Name = "${var.project_name}-${var.environment}-public-subnet-${count.index + 1}"
    },
  )
}
# 3. Private Subnets (Slots 11, 12, 13)
resource "aws_subnet" "private" {
  count                   = length(var.availability_zones)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = cidrsubnet(var.cidr_block, 8, count.index + 11)
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = false       
    
  tags = merge(
    var.tags,
    {
        Type = "Private"
        Name = "${var.project_name}-${var.environment}-private-subnet-${count.index + 1}"
    },
  )
}
# 4. Database Subnets (Slots 21, 22, 23)    
resource "aws_subnet" "database" {
  count                   = length(var.availability_zones)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = cidrsubnet(var.cidr_block, 8, count.index + 21)
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = false       
    
  tags = merge(
    var.tags,
    {
        Type = "Database"
        Name = "${var.project_name}-${var.environment}-database-subnet-${count.index + 1}"
    },
  )
}
# 5. Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.this.id  
    tags = merge(
        var.tags,
        {
            Name = "${var.project_name}-${var.environment}-igw"
            Type = "Core"   
        },
    )
}
# 6. NAT Gateway (placed in Public Subnet 1)
resource "aws_eip" "nat" {
    domain = "vpc"
    tags = merge(
        var.tags,
        {
            Name = "${var.project_name}-${var.environment}-nat-eip"
            Type = "Core"
        },
    )
}   
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id
  tags = merge(
    var.tags,
    {
        Name = "${var.project_name}-${var.environment}-nat-gateway"
        Type = "Core"
    },
  )
  depends_on = [aws_internet_gateway.main] # Ensure IGW is created before NAT Gateway
}

