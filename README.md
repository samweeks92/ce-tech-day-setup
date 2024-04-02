# CE Tech Day setup

This project provides the initial setup for the CE Tech Day

# Project Structure 

| File/Directory                      | Description |
|-----------------------------|-------------|
| [README.md](README.md) | This file. Contains the setup instructions |
| [org-policy-setup.sh](org-policy-setup.sh) | Script to configure Org Policies in the Argolis Project |
| [setup.example.sh](setup.example.sh) | Script to configure IAM Roles for Cloud Build to apply the Terraform |
| [tf](./tf) | This contains all Terraform to build out the Infrastructure and MLOps |

<br>

# Setup Instructions

1. Create a new Project in Argolis

2. From inside that Project, open Cloud Shell.

3. Clone this repo from Cloud Shell:

```
git clone https://github.com/samweeks92/ce-tech-day-setup.git
```

```
cd ce-tech-day-setup
```

2. Assuming you are deploying this into a clean Argolis Project, you will need to reduce the restrictions on certain Organisation Policies before deployment. To do so, you can run the [org-policy-setup.sh](org-policy-setup.sh) file to configure Org Policies appropriately:
```
export GCP_PROJECT_ID=<CHANGE ME>
```
```
gcloud config set project $GCP_PROJECT_ID
```
```
. org-policy-setup.sh
```

3. Review the [setup.sh](setup.sh) file:

This will:
* Set your Project ID , Region 
* Create a GCS Bucket to hold the Terraform state file
* Roll out the Terraform:
  * Enable required APIs
  * Create a VPC
  * Create a Subnetwork with Private Google Access enabled

4. Configure and run the [setup.sh](setup.sh) file:
```
export GCP_PROJECT_ID=<CHANGE ME>
export GCP_REGION=<CHANGE ME> #We have tested for us-central1, but you may want to try with another region
```

```
cp "setup.example.sh" "setup.sh"

sed -i.bak "s/YOUR_PROJECT_ID/$GCP_PROJECT_ID/g" "setup.sh"
sed -i.bak "s/YOUR_GCP_REGION/$GCP_REGION/g" "setup.sh"
rm "setup.sh.bak"
```

```
. setup.sh
```

You will now have a Terraform Apply job running in Cloud Shell. Check it's output and ensure it applies successfully.

Once applied, you can continue with the rest of the lab.