terraform {
  required_version = ">= 0.13"
  
  required_providers {

    google-beta = {
      source  = "hashicorp/google"
      version = ">= 4.46, < 5.0"
    }
  }


}