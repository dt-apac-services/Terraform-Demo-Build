# Terraform-Demo-Build

This Repository once implemented using 'Terraform Apply' will spin up a gcp e2.medium instance with easytravel installed.

There are four different branches:

1. Default:
This build will spin up an e2.medium instance with oneagent and easytravel installed. It will connect to the tenant defined in 'variables.tf' and will shutdown after a period of 2 hours.

2. Fail Scenario:
This build acts the same as Default, however easytravel will fail due to the credit card service being unavailable.

3. No Shutdown:
This build acts the same as Default however it does not shutdown after 2 hours.

4. Fail Scenario NS:
This build acts the same as 'Fail Scenario' however it does not shutdown after 2 hours.
