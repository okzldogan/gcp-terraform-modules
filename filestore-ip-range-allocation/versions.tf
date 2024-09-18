terraform {
  required_version = ">= 0.13"
  
  required_providers {

    google = {
      source  = "hashicorp/google"
      version = ">= 5.0.0, < 5.42.0"
    }
  }


}