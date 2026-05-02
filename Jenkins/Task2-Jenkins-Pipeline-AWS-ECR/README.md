# Task 2: Jenkins Declarative Pipeline for Spring Petclinic (CI/CD to AWS ECR)

## Overview
This project demonstrates a full CI/CD pipeline for a Java Spring Boot application. The pipeline automates the entire lifecycle—from code integration to cloud-native deployment. Since the environment is local, the pipeline is triggered manually to pull the latest changes from GitHub, build the application, containerize it, and push it to AWS Elastic Container Registry (ECR).

## Project Architecture
The following diagram illustrates the technical flow and the integration between local tools (Jenkins, Maven, Docker) and AWS Cloud services:

<p align="center">
  <img src="./Screenshots/1-design_overview.png" width="100%">
  <br>
  <em><b>Figure 1:</b> CI/CD Pipeline Architecture Flow</em>
</p>

---

## Prerequisites
Before running this pipeline, ensure the following are configured:
- **Jenkins Server**: Installed and running locally.
- **Tools**: JDK 17 and Maven 3.9.15 configured in Jenkins Global Tool Configuration.
- **Docker**: Installed and the `jenkins` user added to the `docker` group.
- **AWS CLI**: Configured with an IAM user having ECR permissions.
- **Jenkins Credentials**: AWS Credentials stored with the ID `aws-credentials-id`.
- **Jenkins Plugins**: `Pipeline`, `Docker Pipeline`, `Amazon Web Services SDK`, `Eclipse Temurin installer`.
---

## Installation & Configuration

To enable the local Jenkins server to interact with Docker and AWS, the following setup was performed on the host machine.

### 1. Docker Installation & Permissions
Since Jenkins needs to build and run containers, it must have access to the Docker engine.
- **Install Docker:**
  
```bash
  sudo apt update
  sudo apt install docker.io -y
```
- **Grant Permissions:** Added the `jenkins` user to the `docker` group to execute commands without `sudo`.
```bash
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins
```
- **Verification:** Verified by running `docker ps` as the Jenkins user.

### 2. AWS CLI Setup & ECR Authentication
The AWS CLI is used for authenticating the Docker client with Amazon ECR.
- **Installation:**
  ```bash
  sudo apt install awscli -y
  ```
  - **Verification:** Verified by running `aws --version ` show version of aws cli.

### 3. Jenkins Global Tool Configuration
To ensure the pipeline recognizes the build tools, JDK 17 and Maven 3.9.15 were configured in the Jenkins Dashboard under Manage Jenkins > Global Tool Configuration.

<p align="center">
  <img src="./Screenshots/2-jenkins_tools_conf_jdk17.PNG" width="100%">
  <br>
  <em><b>Figure 2:</b> Jenkins Tools Configure JDK17</em>
</p>

<p align="center">
  <img src="./Screenshots/3-jenkins_tools_conf_maven-3.9.15.PNG" width="100%">
  <br>
  <em><b>Figure 1:</b>  Jenkins Tools Configure Maven 3.9.15 </em>
</p>

### 4. AWS IAM User & ECR Repository Setup
Before configuring Jenkins, we must set up the necessary infrastructure and access levels on the AWS Console.

#### A. Creating IAM User & Access Keys
To allow Jenkins to interact with AWS services, a dedicated **IAM User** was created with programmatic access.
1. Created a user named `jenkins-ecr-user`.
2. Attached the `AmazonEC2ContainerRegistryFullAccess` policy to give the user permission to push/pull images.
3. Generated **Access Key** and **Secret Access Key** from the "Security credentials" tab.

<p align="center">
  <img src="./Screenshots/4-aws_iam_user_keys.png" width="100%">
  <br>
  <em><b>Figure 4:</b> Generating IAM Access Keys for Jenkins</em>
</p>

#### B. Creating AWS ECR Repository
A private repository was created in **Amazon Elastic Container Registry (ECR)** to host our Docker images.
- **Repository Name:** `my-spring-petclinic`
- **Region:** `us-east-1`

<p align="center">
  <img src="./Screenshots/5-aws_ecr_repo_setup.png" width="100%">
  <br>
  <em><b>Figure 5:</b> AWS ECR Repository created for the project</em>
</p>

---

### 5. Jenkins Credentials Configuration
Now, we store the keys we generated in the previous step inside Jenkins.
- **Credential ID:** `aws-credentials-id`
- **Type:** Username with Password (Username = Access Key, Password = Secret Key).

<p align="center">
  <img src="./Screenshots/6-jenkins_credentials.png" width="100%">
  <br>
  <em><b>Figure 6:</b> Mapping AWS Keys to Jenkins Credentials</em>
</p>

---

## Jenkins Pipeline Implementation

In this section, we transition from manual configuration to **Pipeline as Code**. We used a **Declarative Pipeline** (Groovy) to define the automation steps.

### 1. Creating the Pipeline Job
1. In Jenkins, select **New Item** and choose **Pipeline**.
2. Name it `docker-ECR-push-pull`.
3. In the **Pipeline** section, we chose "Pipeline script" and pasted our `Jenkinsfile`.

<p align="center">
  <img src="./Screenshots/7-jenkins_pipeline_job_setup.png" width="100%">
  <br>
  <em><b>Figure 7:</b> Creating the Pipeline Job in Jenkins</em>
</p>

### 2. Pipeline Stages Breakdown (The Jenkinsfile Logic)

#### Stage 1: Environment & System Info
Before starting, Jenkins prints the current system date, user, and path. This is crucial for debugging and ensuring the environment is ready.

<p align="center">
  <img src="./Screenshots/8-stage_system_info.png" width="100%">
  <br>
  <em><b>Figure 8:</b> Stage 1 - System Information Verification</em>
</p>

#### Stage 2: SCM (Cloning the Repository)
Jenkins pulls the latest code from the GitHub repository. Since we are in a local environment, this is triggered manually.

<p align="center">
  <img src="./Screenshots/9-stage_scm_clone.png" width="100%">
  <br>
  <em><b>Figure 9:</b> Stage 2 - Successful SCM (Source Code Management)</em>
</p>

#### Stage 3: Maven Build & Test
This is where the magic happens for Java. Jenkins uses the configured Maven tool to:
- Update `application.properties` to run on port `8081`.
- Run `mvn clean package` to execute tests and generate the JAR file.

<p align="center">
  <img src="./Screenshots/10-stage_maven_build.png" width="100%">
  <br>
  <em><b>Figure 10:</b> Stage 3 - Maven Build & Unit Testing Success</em>
</p>

#### Stage 4: Dockerization (Build & Tag)
Jenkins uses the `Dockerfile` to build the image and tags it with `${env.BUILD_NUMBER}` for versioning and `latest` for production.

<p align="center">
  <img src="./Screenshots/11-stage_docker_build.png" width="100%">
  <br>
  <em><b>Figure 11:</b> Stage 4 - Docker Image Build and Tagging</em>
</p>

#### Stage 5: AWS ECR Authentication & Push
Using the `aws-credentials-id` we created, Jenkins logs into AWS ECR and pushes both tags.

<p align="center">
  <img src="./Screenshots/12-stage_ecr_push.png" width="100%">
  <br>
  <em><b>Figure 12:</b> Stage 5 - Successfully Pushing Image to AWS ECR</em>
</p>

#### Stage 6: Deployment (Run Container)
The final stage cleans up any old container and runs the new one on port `8081`.

<p align="center">
  <img src="./Screenshots/13-stage_deployment.png" width="100%">
  <br>
  <em><b>Figure 13:</b> Stage 6 - Final Local Deployment Success</em>
</p>

---

### 3. Pipeline Execution & Stage View
After triggering the build, we can monitor the progress through the **Jenkins Stage View**. This provides a visual representation of each stage's duration and status.

<p align="center">
  <img src="./Screenshots/14-pipeline_stage_view.png" width="100%">
  <br>
  <em><b>Figure 14:</b> Successful Jenkins Pipeline Stage View (All Green)</em>
</p>

### 4. Application Verification
Once the `Run Container` stage completes, we verify the deployment through two methods:

#### A. Docker Terminal Verification
We check the running containers on the local host to ensure `petclinic-app` is active on port `8081`.
```bash
docker ps
```
<p align="center">
  <img src="./Screenshots/15-docker_ps_verify.png" width="100%">
  <br>
  <em><b>Figure 14:</b> Successful Jenkins Pipeline Stage View (All Green)</em>
</p>

#### B. Web Browser Access
Finally, we access the application via the browser at http://localhost:8081. The Spring Petclinic home page confirms that the entire CI/CD flow—from GitHub to AWS ECR and back to Local Deployment—is working perfectly.

<p align="center">
  <img src="./Screenshots/16-app_web_interface.png" width="100%">
  <br>
  <em><b>Figure 14:</b> Successful Jenkins Pipeline Stage View (All Green)</em>
</p>

## Conclusion
In this task, we successfully built a robust Declarative Pipeline that integrates:

- **Build Tools**: Maven & JDK 17.
- **Containerization**: Docker.
- **Cloud Storage**: AWS Elastic Container Registry (ECR).
- **Automation**: Jenkins CI/CD.

This project highlights the ability to manage complex DevOps workflows even in a local environment with cloud integration.
