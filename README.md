# Laravel Cypress Docker (Gitlab)

This image inherits from `robsontenorio/laravel` by including all required dependencies and browsers for running Cypress:
 - Firefox
 - Chrome
 - Electron

This is a large docker image **intended only** for running Cypress e2e tests on Gitlab. 

**DO NOT** use for it:
 - Local development
 - Building production image


For production use `robsontenorio/laravel` instead.


## Gitlab example

```yaml
image: robsontenorio/laravel  # <--- Good for all steps, except "cypress"

stages:
  - build
  - test
  - deploy

composer:  
  stage: build
  ...

yarn:  
  stage: build  
  ...

phpunit:  
  stage: test
  dependencies:
    - composer
    - yarn    
  ...

cypress:
  image: robsontenorio/laravel-cypress # <--- This image include Cypress dependencies
  stage: test
  dependencies:
    - composer
    - yarn    
  services:
    - name: mysql/mysql-server:8.0.25
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

# Build a final docker image and deploy
production:
   stage: deploy
  ...   
```