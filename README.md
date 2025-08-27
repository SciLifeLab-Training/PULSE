# The SciLifeLab course template

The SciLifeLab template for setting up SciLifeLab branded courses using github pages. It includes:

- Pre-configured GitHub Actions for continuous deployment to GitHub Pages (works out-of-the-box within the SciLifeLab github organization).
- A github workflow for rendering the website and deploying it automatically.
- All pages are rendered using Quarto. For customizations see the official Quarto documentation. While developing the materials you can use quarto to render the pages locally.

You can see how this template looks when rendered at [https://scilifelab-training.github.io/scilifelab-training-template/](https://scilifelab-training.github.io/scilifelab-training-template/). 

## DISCLAIMER
This is the first version of this template, and can thus contain errors. Let us know if there are things that are broken.

## Getting Started

1. When in the template repository, click the button **Use this template**. When creating the template, don't forget to click the checkbox **Include all branches**.
2. Github actions will run directly as you create the repository, and if you have created the repository within the SciLifeLab-Training organization it should finish successfully and create the course page. If you have created the repository outside the organization, you will need to set up the repository secrets, see below.
3. (Outside the organization): create a Personal access token (classic) with access rights to the repository and workflows. Name it ORG_PAT. This will ensure it works directly, otherwise you will need to change the workflow file.
3. Verify that the github actions have finished successfully, and that you can find your course page at https://scilifelab-training.github.io/your-repo-name.

## Configuration

1. This template uses one branch per course instance, allowing you to keep older instances alive on the same website. The branch name should be `release-YYMM` where YYMM is the year and month of the course instance. The branch name is used to generate the URL for the instance. You can either rename the release-0000 branch or create a new branch from it and remove the old one.
2. Switch to the release branch and modify the `_quarto.yml` file to configure branches to use. Push changes.
3. Switch to the gh-pages branch and update the `_config.yml` to change title, description, and repository, and push the changes
5. Now you can go back to your release branch and start modifying the course content. If you have Quarto installed you can use the `quarto render` command to render the pages locally. There is however no need to push the rendered pages, as github actions will do this for you when you push changes to the repository.

## GitHub Actions

Your site will automatically build and deploy when you push changes. If you wish to customize the workflow, see `.github/workflows/main.yml`.
