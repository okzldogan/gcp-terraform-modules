##############################################
### Create PubSub Topic & Subscription #######
##############################################


resource "google_pubsub_topic" "topic" {

    for_each     = var.pubsub_config

    project      = var.project_id


    name         = "${each.key}"

    labels       = var.labels

    message_storage_policy {

        allowed_persistence_regions = [
            "europe-west1",
        ]

    }


}


resource "google_pubsub_topic" "dead_letter" {

    for_each     = var.pubsub_config
    
    name         = "${each.key}-dead-letter-topic"

    project      = var.project_id

    message_storage_policy {

        allowed_persistence_regions = [
            "europe-west1",
        ]

    }

    depends_on = [
        google_pubsub_topic.topic
    ]


}

resource "google_pubsub_subscription" "subscription" {

    for_each     = var.pubsub_config

    project     = var.project_id

    
    name        = join(", ", each.value)

    # name        = element(each.value, 0)
    topic       = "${each.key}"

    labels      = var.labels

    dead_letter_policy {
        dead_letter_topic = google_pubsub_topic.dead_letter[each.key].id
        max_delivery_attempts = 5
    }


    enable_message_ordering    = true

    depends_on = [
        google_pubsub_topic.topic,
    ]

}

resource "google_pubsub_topic_iam_binding" "topic_binding" {

    for_each     = var.pubsub_config
    
    project      = var.project_id
    topic        = each.key
    role         = "roles/pubsub.publisher"

    members = [
        "serviceAccount:${var.pubsub_user_service_account}",
    ]

    depends_on = [
        google_pubsub_topic.topic
    ]

}

resource "google_pubsub_topic_iam_binding" "dead_letter_binding" {

    for_each     = var.pubsub_config
    
    project      = var.project_id
    topic        = "${each.key}-dead-letter-topic"
    role         = "roles/pubsub.publisher"

    members = [
        "serviceAccount:${var.pubsub_user_service_account}",
    ]

    depends_on = [
        google_pubsub_topic.dead_letter
    ]

}

resource "google_pubsub_subscription_iam_binding" "subscription_binding" {

    for_each     = var.pubsub_config

    project      = var.project_id
    
    subscription = join(", ", each.value)
    role         = "roles/pubsub.subscriber"
    members = [
        "serviceAccount:${var.pubsub_user_service_account}",
    ]

    depends_on = [
        google_pubsub_subscription.subscription
    ]
}
