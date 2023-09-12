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
   
  metadata_startup_script = <<-EOT
    sudo yum update;
    sudo yum install -y wget;
    sudo yum install -y java-11-openjdk;
    wget -O /var/tmp/dynatrace-oneagent-latest.sh "${var.dt_tenant_url}/api/v1/deployment/installer/agent/unix/default/latest?arch=x86&flavor=default" --header="Authorization: Api-Token ${var.dt_paas_token}";
    chmod 755 /var/tmp/dynatrace-oneagent-latest.sh;
    sudo ./bin/sh /var/tmp/dynatrace-oneagent-latest.sh ${var.oneagent_args};    
    wget -O easyTravel.jar "https://etinstallers.demoability.dynatracelabs.com/latest/dynatrace-easytravel-linux-x86_64.jar";
    java -jar easyTravel.jar -y;    
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
