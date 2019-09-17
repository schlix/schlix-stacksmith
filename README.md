# schlix-stacksmith

Schlix installer for Bitnami Stacksmith

## How to deploy

1. Go to stacksmith.bitnami.com.
2. Create a new application and select the Generic application with DB (MySQL) stack template.
3. Select the targets you are interested on (AWS, Azure, Kubernetes,...).
4. Go to https://www.schlix.com and download Schlix CMS.
5. Upload schlix-cms zip file for application file.
5. Select Git repository for the application scripts and paste the URL of this repo. Use master as the Repository Reference.
6. Click the Create button. This will start building an image for each of your selected targets.
7. Wait for Schlix CMS to be built, and deploy it in your favorite target platform.
