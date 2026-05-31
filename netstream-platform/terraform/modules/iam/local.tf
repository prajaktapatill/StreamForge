# Load and render the JSON template file
locals {
  jenkins_master_config = jsondecode(templatefile("${path.module}/policies/jenkins_master_policy.json", {
    AWS_ACCOUNT_ID = var.account_id
    AWS_REGION     = var.aws_region
    PROJECT_NAME   = var.project_name
  }))
  jenkins_agent_config = jsondecode(templatefile("${path.module}/policies/jenkins_agent_policy.json", {
    AWS_ACCOUNT_ID = var.account_id
    AWS_REGION     = var.aws_region
    PROJECT_NAME   = var.project_name
  }))
  tf_exec_role_config = jsondecode(templatefile("${path.module}/policies/tf_exec_role_policy.json", {
    AWS_ACCOUNT_ID = var.account_id
    AWS_REGION     = var.aws_region
    PROJECT_NAME   = var.project_name
  }))
}
