provider "azuredevops" {
  org_service_url = "https://dev.azure.com/${var.azdo_organization_name}/"
}

provider "terracurl" {
}

locals {
  authorization_token = base64encode("terraform:${var.AZDO_PAT}")
}

data "azuredevops_project" "project" {
  name = var.project_name
}

//Check if wiki already exists
data "terracurl_request" "wiki" {
  name = "wiki"

  # Read instructions for Terraform
  url    = "https://dev.azure.com/${var.azdo_organization_name}/${var.project_name}/_apis/wiki/wikis/${var.project_name}.wiki?api-version=7.0"
  method = "GET"


  headers = {
    Authorization = "Basic ${local.authorization_token}",
    Content-Type  = "application/json"
  }

  response_codes = [200, 404] //we accept 404 as wiki is not yet created, so module will not report error
}


resource "terracurl_request" "wiki" {
  name = "wiki"

  # Create instructions for Terraform
  url    = "https://dev.azure.com/${var.azdo_organization_name}/${var.project_name}/_apis/wiki/wikis?api-version=7.0"
  method = "POST"


  request_body = <<EOF
{
  "type": "projectWiki",
  "name": "${var.project_name}.wiki",
  "projectId": "${data.azuredevops_project.project.id}",
}
EOF

  headers = {
    Authorization = "Basic ${local.authorization_token}",
    Content-Type  = "application/json"
  }
  skip_tls_verify = true
  response_codes  = [200, 201, 409] //we treat 409 as "wiki already exists", so module will not report error
  retry_interval  = 20              //default interval is to low
}

