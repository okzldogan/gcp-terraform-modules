
terraform {
  required_version = ">= 0.13"
  
  required_providers {

    google = {
      source  = "hashicorp/google"
      version = ">= 4.68, < 5.0"
    }
    
  }

}