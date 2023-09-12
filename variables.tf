variable "project" {
  default = "dxs-apac"
}

variable "region" {
  default = "asia-southeast1"
}

variable "zone" {
  default = "asia-southeast1-b"
}

variable "dt_tenant_url" {
  type = string
  description = "This is the url of your Dynatrace tenancy. Example: https://xzv52984.live.dynatrace.com"
}

variable "dt_paas_token" {
  type = string
  description = "This is the Dynatrace PAAS Token used to download the agent file"
  sensitive = true
}

variable "oneagent_args" {
  type = string
  description = "These are the oneagent arguments used upon installation of the Dynatrace OneAgent"
  default = "--set-host-group=NZ_Terraform"
}


