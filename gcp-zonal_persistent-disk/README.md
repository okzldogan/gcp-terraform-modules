This module creates a zonal persistent disk.

######################################
##### Example Use of the Module ######
######################################


module "zonal_persistent_disk" {
    source          = "../../../terraform-modules/gcp-zonal_persistent-disk/"

    disk_name           = "gke-test-nfs"
    disk_description    = "NFS Test disk for GKE DEV Cluster."
    disk_zone           = "europe-west1-c"

    disk_labels         = {
        application     = "infra"
        type            = "nfs"
        goog-gke-volume = ""    # Normally added by GKE
        environment     = "dev" # Added by GKE Node
    }

    disk_size           = 25
    disk_type           = "pd-ssd"      # Creates an SSD Disk
    disk_project_id     = "<project-id>"

    use_encryption_key      = false                     # Option to Encrypt the Disk
    kms_key_self_link   = "<encrpytion-key-path"


}