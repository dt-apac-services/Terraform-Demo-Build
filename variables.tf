variable "project" {
  default = "dxs-apac"
}

variable "region" {
  default = "asia-southeast1"
}

variable "zone" {
  default = "asia-southeast1-b"
}

variable "dt_tenant" {
  type = string
  description = "This is the ID of the Dynatrace tenant https://_________.live.dynatrace.com"
  default = "xzv52984"
}

variable "agent_arg" {
  type = string
  description = "These are the agent arguments used upon installation of the Dynatrace Agent"
  default = "--set-host-group=NZ_Terraform"
}

variable "dt_token" {
  type = string
  description = "This is the Dynatrace PAAS Token used to download the agent file"
  sensitive = true
}

