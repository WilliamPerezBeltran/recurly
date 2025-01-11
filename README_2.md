# README

Recurly exercises test.

## Stack

- Ruby 3.3.0
- Rails Rails 7.1.3.2

## Installation

To run this project locally, follow these steps:

**Clone the repository**:
   ```bash
   git clone <repository_url>
   cd <project_directory>
   bundle install
   rails server
   ```

## Project Structure

- `app/controllers/api/v1/tins_controller.rb`: Handles the incoming requests for TIN validation.
- `app/services/api/v1/tin_validation_service.rb`: The service responsible for validating TINs according to country-specific rules.
- `app/models/tin.rb`: Defines the `Tin` model which represents the TIN number and country code.
- `config/routes.rb`: Defines the routes for the TIN validation API.
- `spec/`: Contains the test cases for controllers, models, services and routes.

## Running

`rails server`

## Testing

```
rake spec
```

## Format and linters

```
Rubocop
rubocop -a app/
```


https://github.com/voxpupuli/json-schema/


rvm use system && rbenv local 3.3.0 && rbenv version