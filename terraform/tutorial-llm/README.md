# Terraform Instructions

The `*.tf` files in this folder are based on [these scripts](https://github.com/AgnostiqHQ/covalent-awsbatch-plugin/tree/develop/covalent_awsbatch_plugin/assets/infra) from the [covalent-awsbatch-plugin](https://github.com/AgnostiqHQ/covalent-awsbatch-plugin/tree/develop) repository.

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

You should also update your `~/.aws/credentials` file with the same credentials.

```shell
[profile-name]
aws_access_key_id="... "
aws_secret_access_key="... "
aws_session_token="... "
```

### 2. Create AWS resources

Run the following three commands inside this folder (*i.e.* `tutorials_covalent_pydata_2023/terraform/tutorial-llm`).

i. Create initial files, download modules, etc.
```shell
$ terraform init
```

ii. Generate an execution plan.
```shell
$ terraform plan -out "awsbatch.tfplan"
```

iii. Review the output of `terraform plan`. If satisfied, create the infrastructure accordingly.
```shell
$ terraform apply "awsbatch.tfplan"
```

Running `terraform apply` will output the names of relevant variables. Note that you can re-print this any time by running `terraform show`.

### 3. Update executor config

We have to update the AWS Batch executor configuration with these settings. This can be done in the Covalent UI or by using the Covalent SDK, as show below.

(This cell already exists in `3-tutorial-llm.ipynb`)
```python
config = ct.get_config("executors.awsbatch")

# Update the `config` dictionary with new values.
config.update(
    credentials = "/Users/me/.aws/my_credentials",  # must be up to date
    profile = "default",                            # must match credentials
    batch_execution_role_name = "covalent-pydata2023-task-execution-role",
    batch_job_log_group_name = "covalent-pydata2023-log-group",
    batch_job_role_name = "covalent-pydata2023-job-role",
    batch_queue = "covalent-pydata2023-queue",

    # NOTE: This name will be unique. Be sure to update it.
    s3_bucket_name = "covalent-pydata2023-tn1g5duw",
)

# Set the executor's config after updating.
ct.set_config("executors.awsbatch", config)
```

### 4. Destroy resources once finished

To **destroy** the infrastructure, return to this folder and run the following. This will undo everything.

```shell
$ terraform destroy
```
```
Destroy complete! Resources: 19 destroyed.
```
