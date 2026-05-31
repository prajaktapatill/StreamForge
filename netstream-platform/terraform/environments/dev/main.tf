module "iam" {
  source       = "../../modules/iam"
  project_name = var.project_name
  environment  = var.environment
  aws_region   = var.aws_region
  account_id   = data.aws_caller_identity.current.account_id
  sso_user_arn = data.aws_caller_identity.current.arn
}
