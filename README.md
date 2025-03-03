# README

To generate the Swagger JSON creating examples with tests, run the command below:

```sh
SWAGGER_DRY_RUN=0 rake rswag
```

To run tests in parallel

```sh
bundle exec rails parallel:create
bundle exec rails parallel:migrate
bundle exec rails parallel:spec
```

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

- Ruby version

- System dependencies

- Configuration

- Database creation

- Database initialization

- How to run the test suite

- Services (job queues, cache servers, search engines, etc.)

- Deployment instructions

- ...
