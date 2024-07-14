output "pubsub_topic" {
  value = google_pubsub_topic.example_topic.name
}

output "cloud_function_url" {
  value = google_cloudfunctions_function.example_function.https_trigger_url
}

output "cloud_run_service_url" {
  value = google_cloud_run_service.example_service.status[0].url
}
