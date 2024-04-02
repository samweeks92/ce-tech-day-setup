# Check if gcloud SDK is installed
if ! command -v gcloud &>/dev/null; then
  echo "Please install the gcloud SDK."
  echo "https://cloud.google.com/sdk/docs/install-sdk"
  exit 1
fi

# Check if user is authenticated
if ! gcloud auth list &>/dev/null; then
  echo "Please authenticate with the gcloud SDK."
  gcloud auth application-default login
fi

# 1. Get GCP Project ID and Project Number from gcloud
export GCP_PROJECT_ID=YOUR_PROJECT_ID
export GCP_REGION=YOUR_GCP_REGION

# 2. Set Project ID
gcloud config set project $GCP_PROJECT_ID

export GCP_PROJECT_NUMBER=$(gcloud projects describe "$GCP_PROJECT_ID" --format="value(projectNumber)" 2>/dev/null)
export TF_STATE_BUCKET_NAME=$GCP_PROJECT_ID-tf-state

# 3. Enable APIs

gcloud services enable storage.googleapis.com serviceusage.googleapis.com

# 4. Create GCS Bucket for the Terraform Init state

gsutil mb gs://$TF_STATE_BUCKET_NAME
gsutil versioning set on gs://$TF_STATE_BUCKET_NAME

sleep 2

# 5. Apply the Terraform

echo ""
echo "*************************************************"
echo ""
echo "Terraform apply command is starting..."
echo ""
echo "*************************************************"
echo ""

cd tf

terraform init -backend-config=bucket=$TF_STATE_BUCKET_NAME
terraform apply -var project_id=$GCP_PROJECT_ID -var region=$GCP_REGION -var project_number=$GCP_PROJECT_NUMBER -var tf_state_bucket_name=$TF_STATE_BUCKET_NAME --auto-approve

cd ..

echo ""
echo "*************************************************"
echo ""

if [[ $terraform_exit_code -ne 0 ]]; then
  echo "Terraform apply command failed with an error. Please fix and rerun the setup.sh file"
else
  echo "Terraform apply command completed successfully"
fi

echo ""
echo "*************************************************"
echo ""