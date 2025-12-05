terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    # Good practice to define the archive provider explicitly, though not strictly required
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.0"
    }
  }
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda_payload/index.mjs"
  output_path = "${path.module}/lambda_payload/function.zip"
}

# ==============================================================================
# PROVIDERS
# ==============================================================================

# --- America ---
provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

provider "aws" {
  alias  = "us_east_2"
  region = "us-east-2"
}

provider "aws" {
  alias  = "us_west_1"
  region = "us-west-1"
}

provider "aws" {
  alias  = "us_west_2"
  region = "us-west-2"
}

provider "aws" {
  alias  = "ca_central_1"
  region = "ca-central-1"
}

provider "aws" {
  alias  = "sa_east_1"
  region = "sa-east-1"
}

# --- Europe ---
provider "aws" {
  alias  = "eu_central_1"
  region = "eu-central-1"
}

provider "aws" {
  alias  = "eu_west_1"
  region = "eu-west-1"
}

provider "aws" {
  alias  = "eu_west_2"
  region = "eu-west-2"
}

provider "aws" {
  alias  = "eu_west_3"
  region = "eu-west-3"
}

provider "aws" {
  alias  = "eu_north_1"
  region = "eu-north-1"
}

# --- Asia Pacific ---
provider "aws" {
  alias  = "ap_northeast_1"
  region = "ap-northeast-1"
}

provider "aws" {
  alias  = "ap_northeast_2"
  region = "ap-northeast-2"
}

provider "aws" {
  alias  = "ap_northeast_3"
  region = "ap-northeast-3"
}

provider "aws" {
  alias  = "ap_southeast_1"
  region = "ap-southeast-1"
}

provider "aws" {
  alias  = "ap_southeast_2" # Sydney
  region = "ap-southeast-2"
}

provider "aws" {
  alias  = "ap_southeast_4" # Melbourne (Opt-in)
  region = "ap-southeast-4"
}

provider "aws" {
  alias  = "ap_southeast_6" # New Zealand (Opt-in)
  region = "ap-southeast-6"
}

provider "aws" {
  alias  = "ap_southeast_7" # Thailand (Opt-in)
  region = "ap-southeast-7"
}

provider "aws" {
  alias  = "ap_east_1" # Hong Kong (Opt-in)
  region = "ap-east-1"
}

provider "aws" {
  alias  = "ap_south_1"
  region = "ap-south-1"
}

# ==============================================================================
# DEPLOYMENT MODULES
# ==============================================================================

module "us_east_1" {
  source      = "./modules/speed_tester"
  providers   = { aws = aws.us_east_1 }
  region_name = "us_east_1"
  zip_path    = data.archive_file.lambda_zip.output_path
  zip_hash    = data.archive_file.lambda_zip.output_base64sha256
}

module "us_east_2" {
  source      = "./modules/speed_tester"
  providers   = { aws = aws.us_east_2 }
  region_name = "us_east_2"
  zip_path    = data.archive_file.lambda_zip.output_path
  zip_hash    = data.archive_file.lambda_zip.output_base64sha256
}

module "us_west_1" {
  source      = "./modules/speed_tester"
  providers   = { aws = aws.us_west_1 }
  region_name = "us_west_1"
  zip_path    = data.archive_file.lambda_zip.output_path
  zip_hash    = data.archive_file.lambda_zip.output_base64sha256
}

module "us_west_2" {
  source      = "./modules/speed_tester"
  providers   = { aws = aws.us_west_2 }
  region_name = "us_west_2"
  zip_path    = data.archive_file.lambda_zip.output_path
  zip_hash    = data.archive_file.lambda_zip.output_base64sha256
}

module "ca_central_1" {
  source      = "./modules/speed_tester"
  providers   = { aws = aws.ca_central_1 }
  region_name = "ca_central_1"
  zip_path    = data.archive_file.lambda_zip.output_path
  zip_hash    = data.archive_file.lambda_zip.output_base64sha256
}

module "sa_east_1" {
  source      = "./modules/speed_tester"
  providers   = { aws = aws.sa_east_1 }
  region_name = "sa_east_1"
  zip_path    = data.archive_file.lambda_zip.output_path
  zip_hash    = data.archive_file.lambda_zip.output_base64sha256
}

module "eu_central_1" {
  source      = "./modules/speed_tester"
  providers   = { aws = aws.eu_central_1 }
  region_name = "eu_central_1"
  zip_path    = data.archive_file.lambda_zip.output_path
  zip_hash    = data.archive_file.lambda_zip.output_base64sha256
}

module "eu_west_1" {
  source      = "./modules/speed_tester"
  providers   = { aws = aws.eu_west_1 }
  region_name = "eu_west_1"
  zip_path    = data.archive_file.lambda_zip.output_path
  zip_hash    = data.archive_file.lambda_zip.output_base64sha256
}

module "eu_west_2" {
  source      = "./modules/speed_tester"
  providers   = { aws = aws.eu_west_2 }
  region_name = "eu_west_2"
  zip_path    = data.archive_file.lambda_zip.output_path
  zip_hash    = data.archive_file.lambda_zip.output_base64sha256
}

module "eu_west_3" {
  source      = "./modules/speed_tester"
  providers   = { aws = aws.eu_west_3 }
  region_name = "eu_west_3"
  zip_path    = data.archive_file.lambda_zip.output_path
  zip_hash    = data.archive_file.lambda_zip.output_base64sha256
}

module "eu_north_1" {
  source      = "./modules/speed_tester"
  providers   = { aws = aws.eu_north_1 }
  region_name = "eu_north_1"
  zip_path    = data.archive_file.lambda_zip.output_path
  zip_hash    = data.archive_file.lambda_zip.output_base64sha256
}

module "ap_northeast_1" {
  source      = "./modules/speed_tester"
  providers   = { aws = aws.ap_northeast_1 }
  region_name = "ap_northeast_1"
  zip_path    = data.archive_file.lambda_zip.output_path
  zip_hash    = data.archive_file.lambda_zip.output_base64sha256
}

module "ap_northeast_2" {
  source      = "./modules/speed_tester"
  providers   = { aws = aws.ap_northeast_2 }
  region_name = "ap_northeast_2"
  zip_path    = data.archive_file.lambda_zip.output_path
  zip_hash    = data.archive_file.lambda_zip.output_base64sha256
}

module "ap_northeast_3" {
  source      = "./modules/speed_tester"
  providers   = { aws = aws.ap_northeast_3 }
  region_name = "ap_northeast_3"
  zip_path    = data.archive_file.lambda_zip.output_path
  zip_hash    = data.archive_file.lambda_zip.output_base64sha256
}

module "ap_southeast_1" {
  source      = "./modules/speed_tester"
  providers   = { aws = aws.ap_southeast_1 }
  region_name = "ap_southeast_1"
  zip_path    = data.archive_file.lambda_zip.output_path
  zip_hash    = data.archive_file.lambda_zip.output_base64sha256
}

module "ap_southeast_2" {
  source      = "./modules/speed_tester"
  providers   = { aws = aws.ap_southeast_2 }
  region_name = "ap_southeast_2"
  zip_path    = data.archive_file.lambda_zip.output_path
  zip_hash    = data.archive_file.lambda_zip.output_base64sha256
}

module "ap_southeast_4" {
  source      = "./modules/speed_tester"
  providers   = { aws = aws.ap_southeast_4 }
  region_name = "ap_southeast_4"
  zip_path    = data.archive_file.lambda_zip.output_path
  zip_hash    = data.archive_file.lambda_zip.output_base64sha256
}

module "ap_southeast_6" {
  source      = "./modules/speed_tester"
  providers   = { aws = aws.ap_southeast_6 }
  region_name = "ap_southeast_6"
  zip_path    = data.archive_file.lambda_zip.output_path
  zip_hash    = data.archive_file.lambda_zip.output_base64sha256
}

module "ap_southeast_7" {
  source      = "./modules/speed_tester"
  providers   = { aws = aws.ap_southeast_7 }
  region_name = "ap_southeast_7"
  zip_path    = data.archive_file.lambda_zip.output_path
  zip_hash    = data.archive_file.lambda_zip.output_base64sha256
}

module "ap_east_1" {
  source      = "./modules/speed_tester"
  providers   = { aws = aws.ap_east_1 }
  region_name = "ap_east_1"
  zip_path    = data.archive_file.lambda_zip.output_path
  zip_hash    = data.archive_file.lambda_zip.output_base64sha256
}

module "ap_south_1" {
  source      = "./modules/speed_tester"
  providers   = { aws = aws.ap_south_1 }
  region_name = "ap_south_1"
  zip_path    = data.archive_file.lambda_zip.output_path
  zip_hash    = data.archive_file.lambda_zip.output_base64sha256
}

output "urls" {
  value = {
    us_virginia    = module.us_east_1.function_url
    us_ohio        = module.us_east_2.function_url
    us_california  = module.us_west_1.function_url
    us_oregon      = module.us_west_2.function_url
    ca_central     = module.ca_central_1.function_url
    sa_brazil      = module.sa_east_1.function_url
    eu_frankfurt   = module.eu_central_1.function_url
    eu_ireland     = module.eu_west_1.function_url
    eu_london      = module.eu_west_2.function_url
    eu_paris       = module.eu_west_3.function_url
    eu_stockholm   = module.eu_north_1.function_url
    ap_tokyo       = module.ap_northeast_1.function_url
    ap_seoul       = module.ap_northeast_2.function_url
    ap_osaka       = module.ap_northeast_3.function_url
    ap_singapore   = module.ap_southeast_1.function_url
    ap_sydney      = module.ap_southeast_2.function_url
    ap_melbourne   = module.ap_southeast_4.function_url
    ap_newzealand  = module.ap_southeast_6.function_url
    ap_thailand    = module.ap_southeast_7.function_url
    ap_hongkong    = module.ap_east_1.function_url
    ap_mumbai      = module.ap_south_1.function_url
  }
}
