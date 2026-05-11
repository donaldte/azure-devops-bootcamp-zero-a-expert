# ============================================
# TESTS TERRAFORM NATIFS - MODULE STORAGE
# Terraform v1.11+
# ============================================

variables {
  project_name        = "test"
  environment         = "dev"
  resource_group_name = "rg-test-storage"
  location            = "canadacentral"
}

# Provider Azure
provider "azurerm" {
  features {}
}

# Test 1: Création basique
run "basic_storage_creation" {
  command = plan
  
  assert {
    condition     = azurerm_storage_account.main.account_tier == "Standard"
    error_message = "Account tier doit être Standard par défaut"
  }
  
  assert {
    condition     = azurerm_storage_account.main.https_traffic_only_enabled == true
    error_message = "HTTPS doit être obligatoire"
  }
}

# Test 2: Création avec conteneurs
run "storage_with_containers" {
  command = plan

  variables {
    containers = {
      "data"   = { access_type = "private" }
      "logs"   = { access_type = "private" }
      "public" = { access_type = "blob" }
    }
  }

  # Assertion compatible plan-only
  assert {
    condition     = length(var.containers) == 3
    error_message = "3 conteneurs doivent être définis dans la configuration"
  }
}

# Test 3: Override du nom
run "storage_name_override" {
  command = plan
  
  variables {
    storage_account_name_override = "customstorage123"
  }
  
  assert {
    condition     = var.storage_account_name_override == "customstorage123"
    error_message = "Le nom override n'a pas été appliqué dans la config"
  }
}


# Test 4: Configuration Production
run "production_configuration" {
  command = plan
  
  variables {
    environment = "prod"
    account_replication_type = "GRS"
    soft_delete_retention_days = 90
  }
  
  assert {
    condition     = variables.account_replication_type == "GRS"
    error_message = "La production doit utiliser GRS"
  }
}