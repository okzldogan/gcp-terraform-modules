This module creates a key ring and a key under the created key ring. Later you can grant permissions of accessing the key with the key_iam_bindings block.


######################################
##### Example Use of the Module ######
######################################


module "aq_nfs_disk_key" {
  source          = "../terraform-modules/gcp-key-management/"

  key_ring_name             = "<key-ring-name>"   
  key_ring_location         = "my-region"
  project_id                = "<project-id>"
  key_name                  = "<key-name>"
  key_purpose               = "ENCRYPT_DECRYPT"

  key_rotation_period       = "7776000s" # 90 days

  key_generation_algorithm  = "GOOGLE_SYMMETRIC_ENCRYPTION"

  encryption_method   = "SOFTWARE"

  key_labels          = {

    application = "my_app"
    environment = "my_environment"
  }

  key_iam_bindings    = {
    
    "roles/cloudkms.cryptoKeyEncrypterDecrypter" = [
      # GCP SQL Service Account
      "serviceAccount:service-<my-project-id>@gcp-sa-cloud-sql.iam.gserviceaccount.com"
    ]
  }

}