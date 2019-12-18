# AWS Batch Array Job Demo - Calculating Pi

This project includes a CloudFormation template that will configure a simple batch job to calculate Pi using an array jobs. This is a terrible way to calculate Pi. It makes for a good demo, but set expectations that we are not going set any records here.  

## How does it work?

The demo creates a monte Carlo Simulation that generates random numbers and tests if they fall within a circle. Then we use some basic algebra to calculate for Pi. The PowerPoint in the repo will describe this in more detail. Monte Carlo simulations scale out easily. In this demo you can run many containers (e.g. 100) in parallel. The result of each simulation is written to SQS, and then a container runs to summarize everything. 

# Configuring the Demo

The CloudFormation template asks for a VPC, subnet(s), and key pair. The default VPC should work fine. If you deploy in a private subnet, ensure you have a route the internet. You will not need to SSH in for the demo, so the keypair is only needed for debugging. 

The cloud formation template will launch an EC2 instance to initialize the demo and then delete the instance. It will build the initial container image, but if you update the code you must start CodeBuild manually.

Note that when you delete the template, it will leave an ECR repo. You must delete it manually.

# Demo Walkthrough 

Start in **CodeCommit**. Show the calculate.py file that runs the simulation on each node and writes it results to SQS. Then show the summarize.py file that reads the individual simulation results from SQS and summarizes them. Optional spend a few minutes talking about CI/CD, the Dockerfile, and buildspec.yml.  

Now move to **CodeBuild**. Show the build history and build logs. Optionally kick off a new build and watch it run. Note: there is no build trigger so you must start the build manually. Jump over to **ECS** and show the repository. 

Now go to **Batch**. Show the compute environment. Explain that it is using SPOT. Not that the min and desired CPU is 0. Explain that Batch will scale down to zero if there is no work in the queue. 

Now **submit a job**. You must name the job and pick the **Pi-Calculate** job definition and **Pi** queue. Choose **Array** for the job type, and set the array size to 100. You can leave the default values for the remaining inputs. There are defaults in the container definition. Start the job and copy the **Job Id** GUID. 

Now submit another job. Name it, choose the **Pi-Summarize** job type and the **Pi** queue. Leave the job type of **Single** and past the GUID you copied earlier into the **Job depends on** box. Start the job. 

You should now have two jobs in the pending state. The calculate job is waiting for the individual array jobs to finish. The summarize job is waiting for the calculate job to finish. If you click on the calculate job id you can drill in and see the individual tasks running. 

Watch the jobs progress through the queue stages. Optionaly load the SQS console and look at the messages be written to the queue. Maybe open the EC2 console and show the SPOT instance booting/running.

Return to Batch and show that the job has succeeded. Click on the summarize Job ID and then click **View Logs**. Talk about how logs for all services in captured in CloudWatch. The last line in the log should be the estimate for Pi. Don't expect to have more than 3 or 4 decimal places of accuracy.  