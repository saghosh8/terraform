terraform {
  backend "gcs" {
    bucket = "your-gcs-bucket"
    prefix = "terraform/state"
  }
}
