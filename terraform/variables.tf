variable "private_key_path" {
  description = "Path to file containing private key"
  default = "/home/ubuntu/.ssh/badger.pem"
}
variable "fa_url" {
  description = "Cloud Block Store IP Address"
  default = "10.0.1.237"
}
variable "pure_api_token" {
  description = "Cloud Block Store API Token"
  default = "265be729-0ccc-f69b-abf8-f94122eeaf42"
}
