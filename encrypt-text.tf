
resource "google_kms_key_ring" "keyring" {
    
    name        = var.key_ring_name
    location    = var.key_ring_location
    project     = var.project_id

}

resource "google_kms_crypto_key" "crypto_key" {

    
    name            = var.key_name
    key_ring        = google_kms_key_ring.keyring.id
    labels          = var.key_labels
    purpose         = var.key_purpose

    rotation_period = var.key_rotation_period

    version_template {
        algorithm           = var.key_generation_algorithm
        protection_level    = var.encryption_method
    }

    lifecycle {
        prevent_destroy = true      # This lifecycle option prevents Terraform from accidentally removing critical resources.
    }

    depends_on = [google_kms_key_ring.keyring]
}

resource "google_kms_crypto_key_iam_binding" "crypto_key" {

    for_each        = var.key_iam_bindings
    crypto_key_id   = google_kms_crypto_key.crypto_key.id
    role            = each.key

    members         = each.value

    depends_on = [google_kms_crypto_key.crypto_key]
}


# echo -n <your-secret> | gcloud kms encrypt --project <my-kms-project> --location <my-region> --keyring <key-ring-name> --key <crypto-key-name> --plaintext-file - --ciphertext-file - | base64

# Result of the encryption:

# YmlueGlzYXdlc29tZWJpbnhpc2F3ZXNvbWViaW54aXNhd2Vzb21lYmlueGlzYXdlc29tZWJpbnhpc2F3ZXNvbWViaW54aXNhd2Vzb21lYmlueGlzYXdlc29tZQ

# cat <path-to-your-secret> | gcloud kms encrypt --project <project-name> --location <region> --keyring default --key default --plaintext-file - --ciphertext-file - | base64

data "google_kms_secret" "secret_key" {
  crypto_key = data.google_kms_crypto_key.crypto_key.self_link
  ciphertext = "YmlueGlzYXdlc29tZWJpbnhpc2F3ZXNvbWViaW54aXNhd2Vzb21lYmlueGlzYXdlc29tZWJpbnhpc2F3ZXNvbWViaW54aXNhd2Vzb21lYmlueGlzYXdlc29tZQ"
}

# data.google_kms_secret.secret_key.plaintext
