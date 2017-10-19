/**
 * this variable intentionally left blank, see README to configure your shell
 */
variable "assume_role_arn" {
}

variable "aws_region" {
  default     = "us-east-1"
}

variable "instance_type" {
  default     = "t2.small"
}

variable "aws_amis" {
  # these are the amazon linux amis, HVM (SSD) EBS-Backed 64-bit
  # https://aws.amazon.com/amazon-linux-ami/
  default = {
    # N. Virginia
    us-east-1 = "ami-a4c7edb2"
    # Ohio
    us-east-2 = "ami-8a7859ef"
    # Oregon
    us-west-1 = "ami-327f5352"
    # N. California
    us-west-2 = "ami-6df1e514"
    ca-central-1 = "ami-a7aa15c3"
    # Ireland
    eu-west-1 = "ami-d7b9a2b1"
    # Frankfurt
    eu-central-1 = "ami-82be18ed"
    # London
    eu-west-2 = "ami-ed100689"
    # Tokyo
    ap-northeast-1 = "ami-3bd3c45c"
    # Seoul
    ap-northeast-2 = "ami-e21cc38c"
    # Singapore
    ap-southeast-1 = "ami-77af2014"
    # Sydney
    ap-southeast-2 = "ami-10918173"
    # Mumbai
    ap-south-1 = "ami-47205e28"
    # São Paulo
    sa-east-1 = "ami-87dab1eb"
  }
}

variable "build_key" {
  default = ""
}

variable "runner" {
  default = ""
}

variable "java_min_heap" {
  default = "128m"
}

variable "java_max_heap" {
  default = "128m"
}

# EBS type of the volume for the /opt/app directory
# can be gp2, st1, or io1 (don't bother with standard or sc1)
# see: http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/EBSVolumeTypes.html
variable "data_volume_type" {
  default = "gp2"
}

# size of the volume for the /opt/app directory, in GB
# if data_volume_type is st1, this must be >= 500
variable "data_volume_size" {
  default = "10"
}

# if data_volume_type is io1, this value takes effect, ignore for all other types
# maximum value for iops is data_volume_size * 50
# and cannot exceed 20,000
variable "data_volume_iops" {
  default = "500"
}
