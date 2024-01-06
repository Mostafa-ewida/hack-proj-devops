terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.78.0"
    }
  }
}

provider "azurerm" {
  features {}
}



locals {

  #rc vars
  rc-name     = module.rc-group.name
  rc-location = module.rc-group.location
  rc-tags     = module.rc-group.tags


  #compute vars
  
  control_static_private_ip = module.compute.control_static_private_ip
  worker1_static_private_ip = module.compute.worker1_static_private_ip
  worker2_static_private_ip = module.compute.worker2_static_private_ip
  admin_username            = module.compute.admin_username

  #network vars 
  subnet_id         = module.network.subnet_id
  jump_public_ip    = module.network.jump_public_ip
  jump_public_ip_id = module.network.jump_public_ip_id

}


module "rc-group" {
  source = "./modules/rc-group"  # Path to the compute module directory

  # Pass any required variables to the compute module
  # For example:
  # variable_name = value
}


module "compute" {
  source = "./modules/compute"  # Path to the compute module directory
  depends_on = [module.rc-group]

  # Pass any required variables to the compute module
  # For example:
  # variable_name = value
  rc-name           = local.rc-name
  rc-location       = local.rc-location
  rc-tags           = local.rc-tags
  subnet_id         = local.subnet_id
  jump_public_ip    = local.jump_public_ip
  jump_public_ip_id = local.jump_public_ip_id
}

module "network" {
  source = "./modules/network"  # Path to the compute module directory
  depends_on = [module.rc-group]
  # For example:
  # variable_name = value

  rc-name     = local.rc-name
  rc-location = local.rc-location
  rc-tags     = local.rc-tags
}

module "security" {
  source = "./modules/security"  # Path to the compute module directory
  depends_on = [module.network]

  # Pass any required variables to the compute module
  # For example:
  # variable_name = value
  rc-name     = local.rc-name
  rc-location = local.rc-location
  rc-tags     = local.rc-tags
}


module "ansible" {
  source = "./modules/ansible"  # Path to the compute module directory
  depends_on = [module.security]
  # Pass any required variables to the compute module
  # For example:
  # variable_name = value
  rc-name     = local.rc-name
  rc-location = local.rc-location
  rc-tags     = local.rc-tags


  jump_public_ip            = local.jump_public_ip
  control_static_private_ip = local.control_static_private_ip
  worker1_static_private_ip = local.worker1_static_private_ip
  worker2_static_private_ip = local.worker2_static_private_ip
  admin_username            = local.admin_username

}


