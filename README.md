# Demo Terraform Multi-Env Deploy without Workspaces
### Why Terraform?
* Version your Infrastructure 
* Simplified configuration files over CloudFormation
* Infrastructure as code that is in lockstep with feature deployments
* Supports a Myriad of Cloud Providers
* Can spawn up infrastructure across different Cloud Platforms
* Infrastructure orchestration
* One click process to set/teardown everything

### Steps
1. Zip application to deploy & append version number to file
2. cd into directory of environment to deploy
3. First time ONLY in directory will need to `terraform init` for environment
4. When deploying to an environment:
    * Execute `terraform plan -out=plan.pilot` to create plan file
    * Execute `terraform apply plan.pilot` to deploy to Pilot environment    
    
## Pros
* More explicit deployment mechanism
* Less verbose deployment mechanism
* Easy to understand and organize files


## Cons
* Need to create multiple initializations
* Version of application is a little muddy