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


# General Structure of the Code

## 1. Controller `TinsController`

This controller handles the main logic for validating a TIN. It includes a `before_action` filter to preprocess the parameters before the main action (`validation_tin`).

### Actions:
- **before_action**: Preprocesses parameters before executing the validation action.
- **validation_tin**: Main action that validates the TIN according to the established rules.

---
## 2. Models and Services

### 2.1. `Rule` model
ActiveRecord model that represents the rules for TINs from different countries. Each rule defines the format or criteria that the TIN must meet to be considered valid.

### 2.2. `ResponseBuilderService` service
This service builds and organizes the JSON response based on the validation result. It is responsible for structuring the information in a coherent manner to be consumed by the application or client.

### 2.3. `TinValidationService` service
This service is responsible for the TIN validation logic. It performs the checks and applies the specific rules for each country or TIN type, returning whether the validation is successful or not.

### 2.4. `ValidateSchemaService` service
Validates data structures against predefined schemas. This service ensures that the input data complies with the expected format before being processed by other services or actions.



# Flujo de Validación en `validation_tin`

## 1. Validación del País
Verifica si el código de país proporcionado existe en la tabla `rules`. Si no, devuelve una respuesta JSON con un error.

## 2. Creación de Instancias
- Se crea un objeto `Tin` con el código de país y el número de TIN proporcionado.
- Se selecciona el formato adecuado para ese país utilizando el método `select_tin`.

## 3. Validación del Formato
Utiliza el servicio `TinValidationService` para validar el formato del TIN, asegurando que cumpla con las reglas específicas de formato para el país seleccionado.

## 4. Validación Adicional para Australia (AU)
- Se valida el algoritmo del TIN para el caso específico de Australia.
- Llama a un servicio externo (simulado en este caso) para verificar el estado del registro de bienes y servicios (GST).

## 5. Respuesta
Construye un objeto de respuesta con el `ResponseBuilderService` y lo devuelve en formato JSON, conteniendo el resultado de la validación y los mensajes correspondientes.

# Main Components

## 1. `TinValidationService`

### Methods:
- **validate_format?**: Validates the TIN format using regular expressions defined for each country.
- **validate_algorithm?**: Implements an algorithm to validate Australian TIN numbers (ABN).
- **validate_gst_status**: Calls an external service to verify the status of the TIN in the GST registry.

## 2. `ResponseBuilderService`
Organizes the response data, including information about the company if applicable. This service ensures that the JSON response is structured correctly and contains the data required for validation.

## 3. `ValidateSchemaService`
Verifies whether the data structure complies with a predefined JSON schema. This service ensures that the input data is valid and compatible with the required format before processing.

# Important Considerations

## 1. Error Handling
Exceptions are caught and error messages are added to provide a detailed response to the customer. This helps to handle unexpected situations and give clear feedback on what went wrong during the validation process.

## 2. Extensibility
The modular design, which includes services and a model for rules, allows for easy addition of validations for new countries. This ensures that the system can scale and adapt to changes or new validation regulations without complications.

## 3. External API Simulation
The `validate_gst_status` service assumes the existence of a local API to query additional information about the TIN. Although in this case the interaction with an external service is simulated, the structure is prepared to integrate with real APIs in the future.



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
