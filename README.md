# CE Tech Day setup

This project provides the initial setup for the CE Tech Day

# Project Structure 

| File/Directory                      | Description |
|-----------------------------|-------------|
| [REAMDE](README.md) | This file. Contains the setup instructions |
| [org-policy-setup.sh](org-policy-setup.sh) | Script to configure Org Policies in the Argolis Project |
| [setup.sh](setup.sh) | Script to configure IAM Roles for Cloud Build to apply the Terraform |
| [Infra](./infra) | This contains all Terraform to build out the Infrastructure and MLOps |

<br>

# Setup Instructions

1. Clone this repo from Cloud Shell.

```
git clone XXXXXXXXXXXXXX
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
X
Y
Z

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

You will now have a Terraform Apply job running in Cloud Shell. 