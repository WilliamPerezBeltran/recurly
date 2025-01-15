# README

Recurly Exercises Test

## Stack

- **Ruby**: 3.3.0  
- **Rails**: 7.1.5.1

## Installation

To run this project locally, follow these steps:

1. **Clone the repository**:
   ```bash
   git clone <repository_url>
   cd <project_directory>
   bundle install
   rails server
   ```

## Project Structure

- **`app/controllers/api/v1/tins_controller.rb`**: Handles incoming requests for TIN validation.  
- **`app/services/api/v1/tin_validation_service.rb`**: Service for validating TINs based on country-specific rules.  
- **`app/models/tin.rb`**: Model representing TIN numbers and their country codes.  
- **`config/routes.rb`**: Defines routes for the TIN validation API.  
- **`spec/`**: Contains tests for controllers, models, services, and routes.  

## Running

Start the server with:  
```bash
rails server
```

## Testing

Run the tests with:  
```bash
rake spec
```

## Format and Linters

Use **Rubocop** for formatting and linting:  
```bash
rubocop -a app/
```

## References

- [JSON Schema GitHub Repository](https://github.com/voxpupuli/json-schema)

To set the Ruby version:  
```bash
rvm use system && rbenv local 3.3.0 && rbenv version
```

## Server Setup

A simplified server implementation representing the ABN WS (Web Service) API is included in the repository. This mock server can be run using the command:
```bash
bin/abn_query_server.rb
```

## Tree Structure

```
├── 1
├── app
│   ├── controllers
│   │   ├── api
│   │   │   └── v1
│   │   │       └── tins_controller.rb
│   │   ├── application_controller.rb
│   │   └── concerns
│   ├── lib
│   │   ├── structure_schema.rb
│   │   └── tin_rules.rb
│   ├── models
│   │   ├── application_record.rb
│   │   ├── concerns
│   │   ├── rule.rb
│   │   └── tin.rb
│   └── services
│       └── api
│           └── v1
│               ├── response_builder_service.rb
│               ├── tin_validation_service.rb
│               └── validate_schema_service.rb
├── bin
│   ├── abn_query_server.rb
│   ├── bundle
│   ├── docker-entrypoint
│   ├── finish-interview.sh
│   ├── rails
│   ├── rake
│   ├── setup
│   └── setup-repo.sh
├── config
│   ├── application.rb
│   ├── boot.rb
│   ├── credentials.yml.enc
│   ├── database.yml
│   ├── environment.rb
│   ├── environments
│   │   ├── development.rb
│   │   ├── production.rb
│   │   └── test.rb
│   ├── initializers
│   │   ├── cors.rb
│   │   ├── filter_parameter_logging.rb
│   │   └── inflections.rb
│   ├── locales
│   │   └── en.yml
│   ├── puma.rb
│   └── routes.rb
├── config.ru
├── db
│   ├── migrate
│   │   ├── 20241227020131_create_rules.rb
│   │   ├── 20241227024346_add_iso_to_rules.rb
│   │   └── 20241227030155_add_format_length_to_rule.rb
│   ├── schema.rb
│   └── seeds.rb
├── Dockerfile
├── Gemfile
├── Gemfile.lock
├── info
│   └── responde.txt
├── instrucciones
│   ├── recurly_interview.tar (3) (1).gz
│   └── Tax Identification Number Validation API (4) (1).pdf
├── lib
│   └── tasks
├── log
│   ├── development.log
│   └── test.log
├── package.json
├── package-lock.json
├── public
│   └── robots.txt
├── Rakefile
├── README_2.md
├── README.md
├── r.txt
├── spec
│   ├── controllers
│   │   └── api
│   │       └── v1
│   │           └── tins_controller_spec.rb
│   ├── model
│   │   └── api
│   │       └── v1
│   │           ├── rule_spec.rb
│   │           └── tin_spec.rb
│   ├── rails_helper.rb
│   ├── routing
│   │   └── api
│   │       └── v1
│   │           └── tins_controller_spec.rb
│   ├── services
│   │   └── api
│   │       └── v1
│   │           └── tin_validation_service_spec.rb
│   └── spec_helper.rb
├── storage
│   ├── development.sqlite3
│   ├── test.sqlite3
│   ├── test.sqlite3-shm
│   └── test.sqlite3-wal
├── tmp
│   ├── cache
│   ├── local_secret.txt
│   ├── pids
│   │   └── server.pid
│   ├── restart.txt
│   ├── sockets
│   └── storage
└── vendor
