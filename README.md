
## About
This is a template project to get a Docker container up and running with a working selenium server, a headless Chrome 
browser and the Codeception framework as Composer dependency.

### Software
- PHP 8.2
- Google Chrome (+ Driver) 119.0.6045.105
- NVM 0.39.5
  - Node 20.9.0
  - NPM 10.1.0


## Installation
```shell
docker build --tag=phpsel .
docker-compose up -d
```

## Usage
```shell
docker-compose exec php bash
php ./vendor/bin/codecept run --steps
```

## Resources
- https://stackoverflow.com/a/76734752 Install Chrome
- https://stackoverflow.com/a/76156862 Install NPM & Node
- https://codeception.com/docs/modules/WebDriver
