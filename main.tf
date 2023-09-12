terraform {
  required_providers {
    google = {
      source  = "hashicorp/google-beta"
      version = "4.57.0"
    }
    random = {
      source = "hashicorp/random"
      version = "3.4.3"
    }
  }
}

provider "google" {
  project     = "dxs-apac"
  region      = "australia-southeast1"
  zone        = "australia-southeast1-a"
}

resource "random_integer" "priority" {
  min = 1
  max = 50000
}

resource "google_compute_instance" "vm_instance" {
  name = "terraform-instance-${random_integer.priority.id}"
  machine_type = "e2-medium" #This sets the specifications of the VM Instance
  allow_stopping_for_update = true #This allows Terraform to tear down the instance for updates if needed
  
  boot_disk {
    initialize_params {
      image = "rhel-cloud/rhel-8"
    }
  }

  network_interface {
    network = "default"
    access_config {
    }
  }
   
  # service_account{
  #   email = "604381141592-compute@developer.gserviceaccount.com"
	# scopes = ["cloud-platform"]
  # }
  metadata_startup_script = <<-EOT
    curl -X GET "https://${var.dt_tenant}.live.dynatrace.com/api/v1/deployment/installer/agent/unix/default/latest?flavor=default&arch=all&bitness=all&skipMetadata=false&networkZone=default" -H "accept: */*" -H "Authorization: Api-Token ${var.dt_token}" > /var/tmp/dynatrace-install.sh;
    chmod 755 /var/tmp/dynatrace-install.sh;
    sudo ./bin/sh /var/tmp/dynatrace-install.sh ${var.agent_arg};
    echo "installed agent";
    sudo yum update;
    sudo yum install -y wget;
    sudo yum install -y java-11-openjdk;
    echo "passed apt gets";
    # Define variables;
    ET_URL="https://etinstallers.demoability.dynatracelabs.com/latest/dynatrace-easytravel-linux-x86_64.jar";
    ET_TAR="easyTravel.jar";
    DB_PASSWORD="mysecretpassword";
    # Download the EasyTravel tar file;
    wget "$ET_URL" -O "$ET_TAR";
    java -jar easyTravel.jar -y;
    echo "passed easy install";
    printf "[Unit]\nDescription=easytravel\n[Service]\nUser=root\nWorkingDirectory=/root\nExecStart=/bin/bash /easytravel-2.0.0-x64/runEasyTravelNoGUI.sh\nRestart=always\n[Install]\nWantedBy=multi-user.target" >> '/etc/systemd/system/easytravel.service';
    sudo systemctl daemon-reload;
    sudo systemctl start easytravel.service;
    EOT
  scheduling {
    instance_termination_action = "DELETE"
    max_run_duration {
      seconds = 7200
    }
  }
  metadata = {
    enable-oslogin = "TRUE"
  }
}
