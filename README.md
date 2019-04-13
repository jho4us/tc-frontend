# Purpose

Frontend of the test constructor app which is a VueJS/Axios/BootstrapVue app sending info to a Go backend.

# Sources

[VueJS template](https://vuejs-templates.github.io/bootstrap-vue/webpack/structure.html)

# Project setup

1. `cd src`
1. `npm install`
1. `npm run dev`
1. `npm run build`

# Local development

`npm run dev`

# Deployment

## Server

`docker run --net my_network --ip 172.50.0.11 -p 9000:9000 -d --name frontend_v1_container myaccount/myrepo:frontend_v1`