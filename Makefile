# gcp project id
PROJECT_ID=devops-test-362819
# gcp region
REGION=us-central1
# gcp zone 
ZONE=us-central1-a

# run the api locally with docker compose
run-local:
	docker-compose up

###

# gcp bucket to store terraform state
create-tf-backend-bucket:
	gsutil mb -p $(PROJECT_ID) -l $(REGION) gs://$(PROJECT_ID)-terraform

###

# check if env var is set 
check-env:
ifndef ENV
	$(error ENV set ENV=[staging|production])
endif

# Get secret from secret manager
define get-secret
$(shell gcloud secrets versions access latest --secret=$(1) --project=$(PROJECT_ID))
endef

###

# create workspace for each environment
terraform-create-workspace: check-env
	cd terraform && \
		terraform workspace new $(ENV)

# set workspace and initialyze the environment
terraform-init: check-env
	cd terraform && \
		terraform workspace select $(ENV) && \
		terraform init

# pass terraform action (plan|apply) as	make terraform-action TF_ACTION={plan|apply} default is plan
TF_ACTION?=plan
terraform-action: check-env
	@cd terraform && \
		terraform workspace select $(ENV) && \
		terraform $(TF_ACTION) \
		-var-file="./environments/common.tfvars" \
		-var-file="./environments/$(ENV)/config.tfvars"	
#		-var="cloudflare_api_token=$(call get-secret,cloudflare_api_token)"

###

# github sha form github actions to tag the image
GITHUB_SHA?=latest
# build the docker image
LOCAL_TAG=api:$(GITHUB_SHA)
# remote gcp container registry tag
REMOTE_TAG=gcr.io/$(PROJECT_ID)/$(LOCAL_TAG)

# name for the cGke cluster
GKE_CLUSTER_NAME=rest-api-$(ENV)-cluster

###

# Get crendentials for the gke cluster
get-credentials:
	gcloud container clusters get-credentials $(GKE_CLUSTER_NAME) --zone $(ZONE) --project $(PROJECT_ID)

# build the docker image
build:
	docker build -t $(LOCAL_TAG) .

# push the docker image to gcp container registry
push:
	docker tag $(LOCAL_TAG) $(REMOTE_TAG)
	docker push $(REMOTE_TAG)

# deploy the container image to gke cluster using kustomize and kubectl
deploy: check-env
	@echo "edit the image with new tag..."
	kustomize edit set image $(REMOTE_TAG)

	@echo "applying the deployment..."
	@echo "the environment is $(ENV)"

	kustomize build ./$(ENV)/. | kubectl apply -f -

	# rollout deployment
	kubectl rollout restart deployment/restapi-deployment
	kubectl get services -o wide