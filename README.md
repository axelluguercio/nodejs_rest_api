# nodejs_rest_api

This rest api uses nodejs/express with JWT auth.

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

* GKE cluster with 2 nodes
* Storage bucket to store terraform state backend

Using the terraform config requires:

1. Creating a GCP project ( + service account key for terraform to use)
2. Configure API key manager
