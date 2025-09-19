resource "aws_vpc" "my-react-node-app" {
  cidr_block = var.vpc_cidr
  tags       = { Name = "${var.name}-vpc" }
}

# Internet Gateway
resource "aws_internet_gateway" "my-react-node-app" {
  vpc_id = aws_vpc.my-react-node-app.id
  tags   = { Name = "${var.name}-igw" }
}

# Public subnets (loop over both)
resource "aws_subnet" "public" {
  count                   = length(var.public_subnets)
  vpc_id                  = aws_vpc.my-react-node-app.id
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = "${var.aws_region}${element(["a", "b"], count.index)}"
  map_public_ip_on_launch = true
  tags                    = { Name = "${var.name}-public-${count.index}" }
}

# Private subnets (loop over both)
resource "aws_subnet" "private" {
  count             = length(var.private_subnets)
  vpc_id            = aws_vpc.my-react-node-app.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = "${var.aws_region}${element(["a", "b"], count.index)}"
  tags              = { Name = "${var.name}-private-${count.index}" }
}

# NAT Gateway in the first public subnet only
resource "aws_eip" "nat" {
  domain = "vpc"
  tags   = { Name = "${var.name}-nat-eip" }
}

resource "aws_nat_gateway" "my-react-node-app" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id
  tags          = { Name = "${var.name}-nat" }
}

# Route tables
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.my-react-node-app.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-react-node-app.id
  }
  tags = { Name = "${var.name}-public-rt" }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.my-react-node-app.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.my-react-node-app.id
  }
  tags = { Name = "${var.name}-private-rt" }
}

# Associate all public subnets with public RT
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Associate all private subnets with private RT
resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

# Outputs
output "public_subnet_ids" { value = aws_subnet.public[*].id }
output "private_subnet_ids" { value = aws_subnet.private[*].id }