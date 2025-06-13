# 🚀 Project: AWS EC2 Flask Deployment with Terraform

This project automates the deployment of an AWS EC2 instance using **Terraform**. The instance is preconfigured to run a **Python Flask web application (`ani.py`)** automatically at launch.

---

## 🛠️ Features

- 🏗️ Creates a **custom VPC** with:
  - Public **subnet**
  - **Internet Gateway**
  - **Route Table** and association
- 🔐 Configures a **Security Group** allowing:
  - Port **22** (SSH)
  - Port **5000** (Flask app)
- ☁️ Deploys an **EC2 instance** (Amazon Linux 2)
  - Associates a public IP
  - Copies and runs a Python Flask app using `remote-exec`
- 📦 Installs Flask via `pip3`
- 📤 Outputs the public IP of the instance

---

## 📂 File Structure

project-folder/
├── main.tf # Terraform config
├── ani.py # Python Flask app to deploy
├── emekakey # Private SSH key (ignored via .gitignore)
├── emekakey.pub # Public SSH key
├── .gitignore # Prevents sensitive & build files from being pushed
├── README.md # Project documentation

2. Deploy Infrastructure
   terraform init
   terraform validate
   terraform plan
   terraform apply

