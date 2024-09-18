This module creates a filestore instance

######################################
##### Example Use of the Module ######
######################################


module "filestore_instance_staging" {
    source          = "../../../terraform-modules/filestore-instance/"

    filestore_instance_name     = "k8s-volumes-${var.env}"
    filestore_tier              = "BASIC_HDD"
    project_id                  = "${var.prefix}-${var.name}"

    filestore_location          = "europe-west1-c"
    filestore_description       = "Filestore NFS instance for GKE ${var.env} Cluster."

    filestore_vpc_network       = "projects/sp-${var.env}-host-vpc/global/networks/sp-shared-vpc-${var.env}"
    # Use IP Range Name Only at Filestore Creation Phase
    # ip range name: filestore-ip-range-${var.env}
    # After creating the instance use the CIDR Block i.e. 10.202.1.0/29
    filestore_ip_range          = "10.202.1.0/29"
     
    fileshare_name              = "k8s_volumes_01"
    filestore_capacity          = 1024

    nfs_access_config = {
        ## NFS Config for NFS Bastion Host ( READ_WRITE + ROOT Access)
        "NFS-Bastion" = {
            ip_ranges = [
                "10.0.2.5/32"
            ]
            access_mode = "READ_WRITE"
            squash_mode = "NO_ROOT_SQUASH"
            anon_uid    = 0
            anon_gid    = 0
        }
        ## NFS Config for GKE Cluster ( READ_WRITE + NON-ROOT Access)
        "GKE-Cluster" = {
            ip_ranges = [
                "10.10.0.0/16",
                "10.101.0.0/16",
                "10.102.0.0/16"
            ]
            access_mode = "READ_WRITE"
            squash_mode = "ROOT_SQUASH"

            anon_uid    = 123
            anon_gid    = 456
            
        }
    }

    filestore_labels            = {
        environment = "staging"
        cost_center = "infra"
        usage       = "gke"
    }


}