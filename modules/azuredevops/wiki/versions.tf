terraform {
  required_providers {
    terracurl = {
      source  = "devops-rob/terracurl"
      version = "1.0.1"
    }

    azuredevops = {
      source  = "microsoft/azuredevops"
      version = ">= 0.3.0"
    }
  }
}