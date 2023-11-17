#!/bin/bash
sudo yum update -y
sudo yum install -y git
git clone --depth 1 --no-checkout https://github.com/co-zhou/Portfolio.git
cd Portfolio
git sparse-checkout set ecommerce
git checkout
cd ecommerce

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
. ~/.nvm/nvm.sh
nvm install --lts

npx npm-check-updates -u
npm install
npm install -g serve

npm run start

