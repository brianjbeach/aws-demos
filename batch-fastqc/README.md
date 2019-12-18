# AWS Batch Genomics Demo â€“ FastQC

This project includes a CloudFormation template that will configure a simple genomics demo based on FastQC. It will configure AWS Batch along with a CI/CD pipeline to build the FastQC container. 

## What is FastQC?

FastQC is a quality control tool that validates FastQ files. FastQ is a text-based file format for genomics data. FastQC is often the first step in a genomics pipeline to verify the data is good before spending money on alignment. 

## Why FastQC?

FastQC is a great demo for many reasons. 1) Itâ€™s familiar to most anyone working in the genomics space. 2) Itâ€™s relatively fast to execute. 3) It works with files in the 1000 Genome project allowing you to talk about Open Data. 4) It creates nice visual output files. 

# Configuring the Demo

The template asks for a VPC, subnet(s), and key pair. The default VPC should work fine. If you deploy in a private subnet, ensure you have a route the internet. You will not need to SSH in for the demo, so the keypair is only needed for debugging. 

The cloud formation template will launch an EC2 instance to initialize the demo and then delete the instance. It will build the initial container image, but if you update the code you must start CodeBuild manually.

Note that when you delete the template, it will leave an S3 bucket and ECR repo. You must delete them manually.

# Demo Walkthrough 

Start in **CodeCommit**. Show the **Dockerfile** and explain how it download the FastQC file. Show the **fastqc.sh** script and note how S3 copy commands bookend the FastQC. Explain how S3 enables ephemeral computing and saves money. Note that it is reading from the Open Data program. 

Now move to **CodeBuild**. Show the build history and build logs. Optionally kick off a new build and watch it run. Note: there is no build trigger so you must start the build manually.

Jump over to **ECS** and show the repository. 

Now go to **Batch**. Show the compute environment. Explain that it is using SPOT. Not that the min and desired CPU is 0. Explain that Batch will scale down to zero if there is no work in the queue. 

Now **submit a job**. You must name the job and pick a job definition. You can leave the default values for the remaining inputs. There are defaults in the container definition. Watch the job progress through the queue stages. 

The job should get stuck in **runnable** state. Talk about how Batch is provisioning SPOT resources. Open the EC2 console and show the instance booting.

Return to Batch and show that the job has succeeded. Click on the Job ID and then click **View Logs**. Talk about how logs for all services in captured in CloudWatch. The last line in the log should be a link to the output stored in S3. Copy and paste it in a new tab to show the output.  

Optionally run another job and override the default parameters. This time specify InputFile s3://1000genomes/phase3/data/NA21144/sequence_read/ERR047878.filt.fastq.gz

Optionally show the AWS command line interface (CLI). Here are a few examples.

```
aws batch submit-job --job-name FastQC-CLI1 --job-queue FastQC --job-definition FastQC --parameters InputFile=s3://1000genomes/phase3/data/NA21144/sequence_read/ERR047877.filt.fastq.gz
aws batch submit-job --job-name FastQC-CLI2 --job-queue FastQC --job-definition FastQC --parameters InputFile=s3://1000genomes/phase3/data/NA21144/sequence_read/ERR047878.filt.fastq.gz
aws batch submit-job --job-name FastQC-CLI3 --job-queue FastQC --job-definition FastQC --parameters InputFile=s3://1000genomes/phase3/data/NA21144/sequence_read/ERR047879.filt.fastq.gz
aws batch submit-job --job-name FastQC-CLI4 --job-queue FastQC --job-definition FastQC --parameters InputFile=s3://1000genomes/phase3/data/NA21144/sequence_read/ERR048950.filt.fastq.gz
aws batch submit-job --job-name FastQC-CLI5 --job-queue FastQC --job-definition FastQC --parameters InputFile=s3://1000genomes/phase3/data/NA21144/sequence_read/ERR048951.filt.fastq.gz
aws batch submit-job --job-name FastQC-CLI6 --job-queue FastQC --job-definition FastQC --parameters InputFile=s3://1000genomes/phase3/data/NA21144/sequence_read/ERR048952.filt.fastq.gz
aws batch submit-job --job-name FastQC-CLI7 --job-queue FastQC --job-definition FastQC --parameters InputFile=s3://1000genomes/phase3/data/NA21144/sequence_read/ERR251691.filt.fastq.gz
aws batch submit-job --job-name FastQC-CLI8 --job-queue FastQC --job-definition FastQC --parameters InputFile=s3://1000genomes/phase3/data/NA21144/sequence_read/ERR251692.filt.fastq.gz
```