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

mkdir scripts
mkdir scripts/.tmp

cat > ./scripts/.tmp/requireOsLogin.yaml << ENDOFFILE
name: projects/$GCP_PROJECT_ID/policies/compute.requireOsLogin
spec:
  rules:
  - enforce: false
ENDOFFILE

cat > ./scripts/.tmp/shieldedVm.yaml << ENDOFFILE
name: projects/$GCP_PROJECT_ID/policies/compute.requireShieldedVm
spec:
  rules:
  - enforce: false
ENDOFFILE

cat > ./scripts/.tmp/vmCanIpForward.yaml << ENDOFFILE
name: projects/$GCP_PROJECT_ID/policies/compute.vmCanIpForward
spec:
  rules:
  - allowAll: true
ENDOFFILE

cat > ./scripts/.tmp/vmExternalIpAccess.yaml << ENDOFFILE
name: projects/$GCP_PROJECT_ID/policies/compute.vmExternalIpAccess
spec:
  rules:
  - allowAll: true
ENDOFFILE

cat > ./scripts/.tmp/restrictVpcPeering.yaml << ENDOFFILE
name: projects/$GCP_PROJECT_ID/policies/compute.restrictVpcPeering
spec:
  rules:
  - allowAll: true
ENDOFFILE

cat > ./scripts/.tmp/trustedImageProjects.yaml << ENDOFFILE
name: projects/$GCP_PROJECT_ID/policies/compute.trustedImageProjects
spec:
  reset: true
ENDOFFILE

cat > ./scripts/.tmp/allowedPolicyMemberDomains.yaml << ENDOFFILE
name: projects/$GCP_PROJECT_ID/policies/iam.allowedPolicyMemberDomains
spec:
  rules:
  - allowAll: true
ENDOFFILE


gcloud org-policies set-policy ./scripts/.tmp/requireOsLogin.yaml
gcloud org-policies set-policy ./scripts/.tmp/shieldedVm.yaml
gcloud org-policies set-policy ./scripts/.tmp/vmCanIpForward.yaml
gcloud org-policies set-policy ./scripts/.tmp/vmExternalIpAccess.yaml
gcloud org-policies set-policy ./scripts/.tmp/restrictVpcPeering.yaml
gcloud org-policies set-policy ./scripts/.tmp/trustedImageProjects.yaml
gcloud org-policies set-policy ./scripts/.tmp/allowedPolicyMemberDomains.yaml

rm -rf ./scripts/.tmp
rm -rf ./scripts