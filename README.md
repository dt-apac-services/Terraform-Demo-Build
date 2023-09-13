# Terraform Demo Build

This Repository once implemented using 'Terraform Apply' will spin up a gcp e2.medium instance with OneAgent and easytravel installed.

## Pre-requisites

1. [Install Terraform](https://developer.hashicorp.com/terraform/downloads)

2. [Install gcloud CLI](https://cloud.google.com/sdk/docs/install)    
    - Initialize and Authorize gcloud CLI with SSO
        - Project ID: `dxs-apac` (choose appropriate project)
        - Compute Region: `asia-southeast1` (optional)
        - Compute Zone: `australia-southeast1-c` (optional)
    
        ```
        gcloud init
        ```

    - Test access by listing all VMs in the project
        ```
        gcloud compute instances list
        ```

## Steps to spin up VM

1. Clone this git repository to your local machine
```git
git clone https://github.com/dt-apac-services/Terraform-Demo-Build.git
```
2. Change directory to the project path
```
cd <your-path>\Terraform-Demo-Build
```
3. Set your Dynatrace tenancy url and PaaS token as environment variables

In windows:
```powershell
$env:TF_VAR_dt_tenant_url = "https://xxxxxxx.live.dynatrace.com"
$env:TF_VAR_dt_paas_token = "dtxx.xxxx.xxxxx"
```
4. Modify any required variable values in `variables.tf`
> Note: Don't set `dt_tenant_url` and `dt_pass_token` in `variables.tf` as these are already set as environment variables.

5. Run `terraform init` to intialize terraform
6. Run `terraform plan` to do a test run (configuration will not be applied)
7. Run `terraform apply` to run the script. Once complete, the vm name should be printed to the console.
8. Within a few minutes the OneAgent should connect to the tenancy with running easyTravel.
9. Disable monitoring of ProcessGroup `dynatrace.easytravel.launcher.CommandlineLauncher easytravel-*-x*` in Dynatrace tenancy
10. SSH onto your VM and restart easyTravel service
    ```
    sudo systemctl restart easytravel
    ```

> IMPORTANT NOTES: 
> - Make sure to delete the PaaS token after the VM is created. The PaaS token will be shown in plain text in VM details. Security of PaaS token is a planned future enhancement.
> - VM will automatically shutdown after 8 hours. This is to prevent machines left running in the cloud.

## Troubleshooting startup script

SSH into the VM and run below command to see the startup script logs.
```bash
sudo journalctl -u google-startup-scripts.service
```

Run below command to re-run script if required

```bash
sudo google_metadata_script_runner startup
```


## Planned Activity for this Repository

Four different branches:

1. Default:
This build will spin up an e2.medium instance with oneagent and easytravel installed. It will connect to the tenant defined in 'variables.tf' and will shutdown after a period of 2 hours.

2. Fail Scenario:
This build acts the same as Default, however easytravel will fail due to the credit card service being unavailable.

3. No Shutdown:
This build acts the same as Default however it does not shutdown after 2 hours.

4. Fail Scenario NS:
This build acts the same as 'Fail Scenario' however it does not shutdown after 2 hours.
