# Terraform Instructions

The scripts in this folder set up a Dask cluster across several AWS EC2 instances.

## Terraform Installation

See official instructions [here](https://developer.hashicorp.com/terraform/downloads?product_intent=terraform).

### MacOS

```shell
$ brew tap hashicorp/tap
$ brew install hashicorp/tap/terraform
```

### Linux

```shell
$ wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
$ echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
$ sudo apt update && sudo apt install terraform
```

## Usage

### 1. AWS Credentials

First, you'll need AWS credentials. Obtain these from your AWS portal and declare them as environment variables.

```shell
$ export AWS_ACCESS_KEY_ID="... "
$ export AWS_SECRET_ACCESS_KEY="... "
$ export AWS_SESSION_TOKEN="... "
```

### 2. Create AWS resources

Run the following three commands inside this folder (*i.e.* `tutorials_covalent_pydata_2023/terraform/tutorial-dask`).

i. Create initial files, download modules, etc.
```shell
$ terraform init
```

ii. Generate an execution plan.
```shell
$ terraform plan -out "dask.tfplan -var n_workers=2 -var enable_gpu=true"
```

iii. Review the output of `terraform plan`. If satisfied, create the infrastructure accordingly.
```shell
$ terraform apply "dask.tfplan"
```

Running `terraform apply` will output the address of the Dask scheduler. We'll pass this to a `ct.executor.DaskExecutor` in the tutorial.

### 4. Destroy resources once finished

To **destroy** the infrastructure, return to this folder and run the following. This will undo everything.

```shell
$ terraform destroy
```
```
Destroy complete! Resources: 5 destroyed.
```
