terraform {
  backend "local" {}

  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.77.0"

    }
  }
}

provider "azurerm" {
  features {
  }
}

locals {
  location = "East US"
  resource_group_name="my-rg"
  storage_account_name="myrgstorageeventgrid"
  storage_account_tier = "Standard"
  storage_account_replication_type = "LRS"
  storage_queue_name="myq"
  event_domain_name="my-eventgrid-domain"
  event_domain_topic_name="my-eventgrid-domain-topic"
  subscription_name="my-subs"
  event_type_names=["your-event-type"]
}

resource "azurerm_resource_group" "example" {
    name = local.resource_group_name
    location = local.location
}

resource "azurerm_storage_account" "example" {
    resource_group_name = azurerm_resource_group.example.name
    name = local.storage_account_name
    location = azurerm_resource_group.example.location
    account_tier = local.storage_account_tier
    account_replication_type = local.storage_account_replication_type
    depends_on = [ azurerm_resource_group.example ]
}

resource "azurerm_eventgrid_domain" "example" {
  name                = local.event_domain_name
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  depends_on = [ azurerm_storage_account.example ]
}

resource "azurerm_eventgrid_domain_topic" "example" {
  name                = local.event_domain_topic_name
  domain_name         = azurerm_eventgrid_domain.example.name
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_storage_queue" "example" {
  name                 = local.storage_queue_name
  storage_account_name = azurerm_storage_account.example.name
}

resource "azurerm_eventgrid_event_subscription" "example" {
  name  = local.subscription_name
  scope = azurerm_eventgrid_domain.example.id
  included_event_types = local.event_type_names

  storage_queue_endpoint {
    storage_account_id = azurerm_storage_account.example.id
    queue_name         = azurerm_storage_queue.example.name
  }
}

output "domain_endpoint" {
    value = azurerm_eventgrid_domain.example.endpoint
}

output "domain_key" {
    value = azurerm_eventgrid_domain.example.primary_access_key
    sensitive = true
}

output "queue_connection_string" {
    value = azurerm_storage_account.example.primary_connection_string
    sensitive = true
}

output "queue_name" {
  value = azurerm_storage_queue.example.name
}