terraform {
  #backend "azurerm" {
  #  storage_account_name = "stterraformitaa"
 #   container_name       = "tfstate"
 #   key                  = "iac-active-directory-core-stack.terraform.tfstate"
  #}
  backend "local" {}

  required_providers {
    azurerm = {
      # The "hashicorp" namespace is the new home for the HashiCorp-maintained
      # provider plugins.
      #
      # source is not required for the hashicorp/* namespace as a measure of
      # backward compatibility for commonly-used providers, but recommended for
      # explicitness.
      source  = "hashicorp/azurerm"
      version = "=2.49.0"
    }
  }
}

provider "azurerm" {
  features {}
}