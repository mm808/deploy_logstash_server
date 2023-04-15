# README #
This project is for setting up a Logstash server and configuring the pipeline files so data can get pushed to OpenSearch Service domains. It uses variables to configure servers across various AWS accounts. The original use was for pushing a LoadBalancer log zip files from their S3 bucket to the OpenSearch Service domains.      

### Configuration Details ###
- The ami for the server is a declared variable instead of using a ssm-parameter lookup because using the parameter is considered sensitive data and will require a server replacement even when we are doing an update for something like adding a new Logstash .conf file. Be sure to check https://cloud-images.ubuntu.com/locator/ec2/ and find the right Ubuntu 20.04 item (or later as time goes by) in the region and update the variable *ami_value*
- The server is deployed with default Logstash configuration and one pipeline for the LoadBalancer logs. The inital Logstash pipeline config file ({env}_""_api_lblogs.conf) is in the infrastructure/terraform/modules/server_config_files directory for TerraForm to deploy with the server bootstrap process. This is added an aws_s3_object resource in the infrastructure/terraform/modules/s3_file/s3.tf file along with the CloudWatch agent. These files will get pushed to the appropriate s3 bucket by this project. The bootstrap process uses a script to pull all files from that location to the server.    
- The file infrastructure/terraform/server_config_files/config.json configures the CloudWatch agent so memory and disk use monitoring can be implemented. The CloudWatch agent and alarms will not work correctly with out this file.    
- After the inital bootstrap of the server has been done, add the .conf files for new Logstash pipelines in infrastructure/ansible/files. The 'update' action of the Jenkins pipeline will run the Ansible playbook that pushes these new files to the server.   
- The server is sized as a t2.medium. This may be too big for your needs or potentially too small if you send a lot through this server. Resize the server accordingly to needs and cost constraints.   

### To configure a new Logstash pipeline ###
- If new logs will be coming from a s3 bucket, update the infrastructure/terraform/modules/ec2/iam.tf file in the server_policy resource by adding the source bucket where the new logs will be coming from. Then run the 'deploy' stage of the Jenkins pipeline to configure the new permissions allowing access to the bucket.    
- Add the .conf files for new Logstash pipelines in infrastructure/ansible/files directory. Update the infrastructure/ansible/files/{env}_pipelines.yml file to include the new .conf file following the pattern of existing items. Then run the 'update' action of the Jenkins pipeline to run the Ansible playbook that pushes these new files to the server.      

### Deployment instructions ###
The COMMIT parameter for running the pipeline can either be the hash of a commit or the branch name.   
- The 'deploy' pipeline action is used for bootstrapping a new server and for establishing new permissions to an s3 bucket where logs may be coming from.    
- The 'update' action will copy new Logstash .conf files to the server and configure it to pick up the new pipeline.          

Once the Logstash server has been bootstrapped or updated you must go to the respective OpenSearch domain and add the index for whatever the new log source is. Go to the triple line menu at the top left>Stack Management>Index Patterns>Create index pattern>    
- for example use _company-api-lblogs*_ to create an index for for the company-api load balancer logs



**Repo owner or admin**   
Original creation by matt.mangione@company.com   
Repo owners company DevOps group and Connect team
