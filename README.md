# nodejs_rest_api

This rest api uses nodejs/express.

It uses Docker + docker-compose for local execution, Terraform to automate the provisioning of cloud resources and Github Actions workflow to automating the test, build and deployment to a GKE cluster taking care of different environment (production|staging).

### Local Setup
---

run api local to test with docker-compose with:

```
make run-local
```

### Terraform
---

The terraform configuration provisions:

* GKE cluster with 1 nodes (for staging) or zonal cluster with 2 nodes (prod). Ingress load balancer to redirect traffic between the nodes.
* VPC for kubernetes
* Service accounts for gke and workloads identity
* Storage bucket to store terraform state backend

Using the terraform config requires:

1. Creating a GCP project ( + service account key for terraform with the iam roles to use):
    - roles/storage.object.Admin
    - roles/compute.network.create
    - roles/compute.firewalls.create
    - roles/service.accounts.Admin
2. Export key as json and store in the terraform folder.
3. Configure API key manager
4. Enable google apis

```
gcloud services enable --async \
  container.googleapis.com
```

### Workflow

The main purpose of this project is to easily change beetween multiple environment whithout overheads.
- Makefile for automating some steps with terraform, the pipeline will be using it to build, push and deploy.
- pipeline steps:
    * Test
    * delivery
- The workflow will select the environment by taking the refs of the git push request.

### Test the API

To test the api, first it has to make a POST request to $(HOST)/DevOps/token, which will return a token to make the request.
Token will expired in 6s.

```
# save host url
export HOST=<hostname/ip-address given>

# Get the token
JWT=$(curl -s -X POST -H 'Accept: application/json' -H 'Content-Type: application/json' --data '{"username":"{username}","password":"{password}","rememberMe":false}' http://${HOST}/DevOps/token)

# Make the request
curl -X POST -H "X-Parse-REST-API-Key:2f5ae96c-b558-4c7b-a590-a501ae1c3f6c" \
        -H "X-JWT-KWY:${JWT}" \
        -H "Content-Type: application/json" \
        -d '{"message": "This is a test","to": "Juan Perez","from": "Rita Asturia","timeToLifeSec":"45"}' http://${HOST}/DevOps
```

### Notice

The purpose of the project is to test the endpoint. As the request require send secrets api key and token to the header, traffic should be encrypted with https and tls's certificates, which are out of the scope of the test for Gke intances, however I create a render deployment which provide a free tls layer.

To test render deployment with https

```
JWT=$(curl -s -X POST -H 'Accept: application/json' -H 'Content-Type: application/json' --data '{"username":"{username}","password":"{password}","rememberMe":false}' https://rest-api-devops-test.onrender.com/DevOps/token)

curl -X POST -H "X-Parse-REST-API-Key:2f5ae96c-b558-4c7b-a590-a501ae1c3f6c" \
        -H "X-JWT-KWY:${JWT}" \
        -H "Content-Type: application/json" \
        -d '{"message": "This is a tes","to": "Juan Perez","from": "Rita Asturia","timeToLifeSec":"45"}' \
        https://rest-api-devops-test.onrender.com/DevOps
```
