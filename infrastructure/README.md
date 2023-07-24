# Template Terraform Infrastructure for AWS

## Synopsis

Create infrastructure as a code for AWS based using terraform solution.

## Usage


### Initial configuration

Create a file "terraform.tfvars" with the AWS credentials:

```
access_key_dev="YOUR ACCESS KEY ID HERE"
secret_key_dev="YOUR SECRET KEY HERE"
access_key_preprod="YOUR ACCESS KEY ID HERE"
secret_key_preprod="YOUR SECRET KEY HERE"
access_key_prod="YOUR ACCESS KEY ID HERE"
secret_key_prod="YOUR SECRET KEY HERE"
```

Create a file "terraform-backend.tfvars" with the AWS credentials:

```
access_key="YOUR ACCESS KEY ID HERE"
secret_key="YOUR SECRET KEY HERE"
```

Them init your local instance.

```
terraform init -reconfigure --backend-config terraform-backend.tfvars --upgrade
```

You will also need the prod and preprod pem key for certain servers, which you must get with either a previous developer or with the infrastructure team.


### Select workspace (environment)

The default environment is not used.

To change to staging:

```
terraform workspace select staging 
```

To change to prod:

```
terraform workspace select prod
```
### View changes

```
terraform plan
```

### Apply changes

```
terraform apply
```


