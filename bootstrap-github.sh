#!/bin/bash -e

GITHUB_REPO_URL=$1
GITHUB_ACCOUNT_EMAIL=$2
GITHUB_ACCOUNT_USER_NAME=$3
GITHUB_ACCESS_TOKEN=$4

# Setup git global config

git config --global user.name=$GITHUB_ACCOUNT_USER
git config --global user.email=$GITHUB_ACCOUNT_EMAIL

# Setup remote

cd ~/workspace/pal-tracker
git remote add origin ${GITHUB_REPO_URL}
git push origin main
