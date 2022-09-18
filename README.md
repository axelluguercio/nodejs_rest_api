# nodejs_rest_api

This rest api uses nodejs/express.

It uses Docker + docker-compose for local execution, Terraform to provision cloud resources and Github Actions for CI/CD.

### Local Setup
---

run

```
make run-local
```

### Terraform
---

The terraform configuration provisions:

* GKE cluster with 1 nodes (for staging) or multiregional cluster with 3 nodes (prod). Current cluster is for staging as for the test purpose
* Storage bucket to store terraform state backend

Using the terraform config requires:

1. Creating a GCP project ( + service account key for terraform with the iam roles to use):
    - roles/storage.object.Admin
    - roles/compute.network.create
    - roles/compute.firewalls.create
    - roles/service.accounts.Admin

2. Configure API key manager

### Workflow

The main purpose of this project is to easily change beetween multiple environment whithout overheads.
- Makefile for automating some steps with terraform, the pipeline will be using it to build, push and deploy.
- pipeline steps:
    * Test
    * delivery
  The workflow will select the environment by taking the refs of the git push request.

### Test the API

To test the api, first it has to make a POST requesto to $(HOST)/DevOps/token, which will return a token to make the request.

```
# save host url
export HOST=<hostname/ip-address given>

# Get the token
JWT=$(curl -s -X POST -H 'Accept: application/json' -H 'Content-Type: application/json' --data '{"username":"{username}","password":"{password}","rememberMe":false}' http://$(HOST)/DevOps/token)

# Make the request

curl -X POST -H "X-Parse-REST-API-Key:2f5ae96c-b558-4c7b-a590-a501ae1c3f6c" \
        -H "X-JWT-KWY:${JWT}" \
        -H "Content-Type: application/json" \
        -d '{"message": "This is a test","to": "Juan Perez","from": "Rita Asturia","timeToLifeSec":"45"}' \
        http://$(HOST)/DevOps
```