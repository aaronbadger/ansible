variable "private_key_path" {
  description = "Path to file containing private key"
  default = "/home/ubuntu/.ssh/badger.pem"
}
variable "fa_url" {
  description = "Cloud Block Store IP Address"
  default = "10.0.0.25"
}
variable "pure_api_token" {
  description = "Cloud Block Store API Token"
  default = "8e8c0984-8761-c3d2-2dcb-f3313b0db294"
}
