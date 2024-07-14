resource "google_pubsub_topic" "example_topic" {
  name = "example-topic"
}

resource "google_pubsub_subscription" "example_subscription" {
  name  = "example-subscription"
  topic = google_pubsub_topic.example_topic.id
}

resource "google_cloudfunctions_function" "example_function" {
  name        = "example-function"
  description = "Example Cloud Function"
  runtime     = "nodejs16"
  entry_point = "helloPubSub"

  event_trigger {
    event_type = "google.pubsub.topic.publish"
    resource   = google_pubsub_topic.example_topic.id
  }

  source_archive_bucket = google_storage_bucket.function_source_bucket.name
  source_archive_object = google_storage_bucket_object.function_source_archive.name
  trigger_http          = false
}

resource "google_storage_bucket" "function_source_bucket" {
  name     = "example-function-source"
  location = var.region
}

resource "google_storage_bucket_object" "function_source_archive" {
  name   = "example-function-source.zip"
  bucket = google_storage_bucket.function_source_bucket.name
  source = "path/to/your/function/source.zip"
}

resource "google_cloud_run_service" "example_service" {
  name     = "example-service"
  location = var.region

  template {
    spec {
      containers {
        image = "gcr.io/${var.project_id}/example-service"
        ports {
          container_port = 8080
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

resource "google_cloud_run_service_iam_member" "example_service_invoker" {
  service = google_cloud_run_service.example_service.name
  location = google_cloud_run_service.example_service.location
  role = "roles/run.invoker"
  member = "allUsers"
}
