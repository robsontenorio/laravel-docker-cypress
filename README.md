<p align="center">
  <img src="octopus.png"> <img height="50" src="cypress.png">
</p> 
<p align="center">    
  <img src="https://img.shields.io/docker/v/robsontenorio/laravel-cypress?color=green&sort=semver&style=for-the-badge" />
  <img src="https://img.shields.io/docker/pulls/robsontenorio/laravel-cypress?color=orange&style=for-the-badge" />
  <img src="https://img.shields.io/docker/image-size/robsontenorio/laravel-cypress?sort=date&style=for-the-badge" />
</p>

# Laravel Docker + Cypress

This image inherits from [robsontenorio/laravel](https://github.com/robsontenorio/laravel-docker) by including all required dependencies and browsers for running Cypress:
 - Firefox
 - Chrome
 - Electron

 **INTENDED ONLY** for running Cypress tests on CI. For local development and production use [robsontenorio/laravel](https://github.com/robsontenorio/laravel-docker) instead.


## Gitlab example

```yaml
image: robsontenorio/laravel  # <--- Good for all steps, except "cypress"

stages:
  - build
  - test
  - deploy

# Install PHP dependencies
composer:  
  stage: build
  ...

# Install JS dependencies
yarn:  
  stage: build  
  ...

# PHP tests
phpunit:  
  stage: test
  dependencies:
    - composer
    - yarn    
  ...

# E2E tests 
cypress:
  image: robsontenorio/laravel-cypress # <--- This image includes Cypress dependencies
  stage: test
  dependencies:
    - composer
    - yarn    
  services:
    - name: mysql:8.0.25
    - name: redis:6.2.4
  variables:        
    MYSQL_DATABASE: mydb
    MYSQL_USER: mydb-user
    MYSQL_PASSWORD: password
    MYSQL_ROOT_PASSWORD: password    
    CYPRESS_CACHE_FOLDER: "$CI_PROJECT_DIR/cache/Cypress"    
    APP_ENV: local
    APP_URL: http://localhost:8080
  script:
    - php artisan migrate:fresh --seed --force --ansi
    - php artisan serve --quiet --port=8080 &        
    - npx cypress install        
    - npx cypress run  --browser chrome
  cache:
    key: ${CI_COMMIT_REF_SLUG}-cypress
    paths:
      - cache/Cypress
  artifacts:
    when: on_failure
    expire_in: 1 week    
    paths:      
      - cypress/screenshots/**/*.png

# Build production final docker image and deploy it (optional)
production:
   stage: deploy
   image: docker:latest
   only:
    - tags
   script:
    - docker login <...>
    - docker build <...>
    - docker push <to some registry>
```