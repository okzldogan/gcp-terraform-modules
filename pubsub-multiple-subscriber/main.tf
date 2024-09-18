locals {
    pubsub_parameters = {
        for items in var.subscription_config:
            items.subscriber_name=> items
   
    }
}



##############################################
### Create PubSub Topic & Subscription #######
##############################################


resource "google_pubsub_topic" "pubsub_topic" {

    project      = var.project_id


    name         = var.topic_name

    labels       = var.labels

    message_storage_policy {

        allowed_persistence_regions = [
            "europe-west1",
        ]

    }


}


resource "google_pubsub_topic" "pubsub_dead_letter" {
    
    name         = "${var.topic_name}-dead-letter-topic"

    project      = var.project_id

    message_storage_policy {

        allowed_persistence_regions = [
            "europe-west1",
        ]

    }

    depends_on = [
        google_pubsub_topic.pubsub_topic
    ]


}

resource "google_pubsub_subscription" "subscription" {

    for_each     = local.pubsub_parameters

    project     = var.project_id

    
    name        = "${each.value.subscriber_name}"

    topic       = "${var.topic_name}"

    labels      = var.labels

    dead_letter_policy {
        dead_letter_topic = google_pubsub_topic.pubsub_dead_letter.id
        max_delivery_attempts = 5
    }


    enable_message_ordering    = true

    depends_on = [
        google_pubsub_topic.pubsub_topic,
    ]

}

resource "google_pubsub_topic_iam_binding" "topic_binding" {
    
    project      = var.project_id
    topic        = google_pubsub_topic.pubsub_topic.id
    role         = "roles/pubsub.publisher"

    members = [
        "serviceAccount:${var.pubsub_user_service_account}",
    ]

    depends_on = [
        google_pubsub_topic.pubsub_topic
    ]

}

resource "google_pubsub_topic_iam_binding" "dead_letter_binding" {
    
    project      = var.project_id
    topic        = "${var.topic_name}-dead-letter-topic"
    role         = "roles/pubsub.publisher"

    members = [
        "serviceAccount:${var.pubsub_user_service_account}",
    ]

    depends_on = [
        google_pubsub_topic.pubsub_dead_letter
    ]

}

resource "google_pubsub_subscription_iam_binding" "subscription_binding" {

    for_each     = local.pubsub_parameters

    project      = var.project_id
    
    subscription = "${each.value.subscriber_name}"
    role         = "roles/pubsub.subscriber"
    members = [
        "serviceAccount:${var.pubsub_user_service_account}",
    ]

    depends_on = [
        google_pubsub_subscription.subscription
    ]
}
