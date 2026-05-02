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
