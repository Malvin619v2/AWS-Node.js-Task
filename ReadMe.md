# PodPoint Task

![N|Solid](https://www.alternergy.co.uk/media/catalog/category/pod-point-logo.jpg)

# Introduction:

This is a file detailing the creation of the podpoint task and the process I went through. I will also detail how to use and run the task. We want to dockerise and deploy `helloWorld.js` to Amazon Web Services with their Elastic Container Service, we want a secure isolated environment and we want to run multiple containers on a instance.


# Tools used:
  - Linux Environment (ubuntu 18)
  - Docker
  - Git
  - Node.JS
  - Amazon CLI
  - Amazon AWS
  - Terraform

# Instructions:
1. In terminal, install tools:
.  - Terraform
.  - Amazon CLI
2. Download the repository files: https://github.com/Malvin619v2/PodPoint-Task.git
3. Unzip and extract files to a location where you want to use terraform and run
4. On terminal, change to the location where you have unziped the files
5. Run:
```sh
$ Terraform init
$ Terraform plan
$ Terraform apply
```
6. The Output should be the Server address where the helloworld app is running
7. Copy the address to a web browser to see the container running the app

# What principles did I apply?:
1. I first created my environment to deploy my node.js app to AWS using Docker. To do this I had to install Node & NPM to my local machine. Next I installed Docker to my machine. To test this I ran the `$docker --version` command to find out if it was properly installed. Next I logged into my AWS account. Last I installed the amazon CLI tool to interract with amazon CLI. I used the command `amazon --version` to verify if it was installed properly.

2. From the terminal I had to Install NPM, initialise it, create the helloworld.js file and open the file for editing. I copied and pasted the config file from the one given to me and pasted it to a new node.js file. I lastly ran my app on the terminal with the command `$node helloworld.js`. Lastly to view the file I pasted `http://localhost:3000` on a browser to view the helloworld file. The commands I used are indicated below:
```
// create a new directory
$ mkdir sample-app
// change to new directory
$ cd sample-app
// Initialize npm
$ npm init -y
// install express
$ npm install express --save
// create a server.js file and open it
$ touch server.js
$ open server.js
```
3. I next created the dockerfile with `$touch Dockerfile` and configured it to run the node in the container.

4. I then built the app with the command `$docker build -t helloworld-app`, After I checked the image was up and running with command `$docker images` and it was visible. I then ran the container to see if it was working correctly. Command: `$docker run -p 80:3000 (name of the docker image)`

5. Pushing the container to the amazon ECR register. I configured my aws with my credentials with `$aws configure`. With this i was able to insert the key, secret access key from the user, my region name and lastly the output format (output was blank). Next I logged into amazon ecr and created a repository from the console which was named 'helloworld-app'.

6. I was then given instructions from the console to push the app created to the ECR registry with:
```
$ (aws ecr get-login --no-include-email --region us-east-2)
$ docker build -t helloworldjs-app .
$ docker tag helloworldjs-app:latest 203261016281.dkr.ecr.us-east-2.amazonaws.com/helloworldjs-app:latest
$ docker push 203261016281.dkr.ecr.us-east-2.amazonaws.com/helloworldjs-app:latest
```
7. Lastly the creation of the interface Terraform environment was created on ATOM ide where I have highlighted the use and reasons for implementing the code in the comments.

# The Decision I made and why it was the best approach:
Initially the choice to create the app was easier to do and deply using the amazon console, which I was successful on creating and deploying to a ec2 container. When I received more clarity on the details I then proceeded to do the same thing but using the terraform tool. Essentially I created:
- variables.tf: This file put the information of the ec2 instance and how to provision it. Information such as the instance type, the image and the location of the app was configured in.
- ecs.tf: Handles the launch configurations of the instance and implements the right settings from the config given.
- myapp.tf: The information about the app running will be in the myapp.tf file. this also details the load balancer information for how it will handle traffic.
- vpc.tf: this is the network configuration for the instance that will run
- securitygroup.tf: The security group makes sure the right permissions are running for the task to work properly along with policy and role information.
- provider.tf: The infomation here is how terraform will connect to aws and which information to go by such as region and cloud provider.
- iam.tf: This file adds more infromation about the app that will be created. These are added from json tags along with calling policies already on aws provided the user has the policies attached to the user.
# The expected output & details:
The expected output will be terraform building the application with the right configuration. It will then output the server address which can then be pinged or put on a browser to see the app up and running. From looking at the console, it should grab the app from the ecr database, use the cluster created along with the service and tasks that was created with it. The end result would be the instance up and running along with the node running from the container
# Recommendation for future work:
I wish I knew more information and knowledge about terraform to undertand specifically which resource is being used according to aws.
# Problems I ran into during the challenge:
The main problems I faced with the tasks were:
1. Compatibility problems: Installing the right versions of the tools and making sure they were compatible with the version of linux I was using. Terraform was causing problems with the version I was running but this was rectified in the end.
2. The main problem I faced is the policy errors. I have double checked to see if a specific policy had been added to my user, however im thrown the error: `Error creating launch configuration: ValidationError: Invalid IamInstanceProfile: {aws_iam_instance_profile.ecs-ec2-role.id}`. I have went over my aws settings to see if the profile is available, its there but it cannot recognise it. It searches for it from the aws URL that handles the profile but I still havent found a resolution for it.
- Update: I was able to fix the policy error by adding tags to the ecs.tf file. My guess is that it was not able to identify the correct configuration which was associated with the right resource.
# Infrastructure Diagram:
- *Note: (diagram has been added to repository)*
# Additional comments:
The reason for taking a little longer than usual would be because of my setup. I tried to install docker on windows which was virtually non existent with my OS because it only works with windows 10 pro and I was using the home edition. Apparently it has the right settings for it to work. I found a way around it, however throughout the process of the doing the task, it wasnt able to work so I moved to using a portable linux. This was a mistake because the portable linux was not capable to saving files after shutdown which meant lost all my work. My last resolution I went with was installing linux (ubuntu) on virtualbox.
