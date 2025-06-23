# Spring Boot User Management System with Multi-Format Data Support

A comprehensive Spring Boot application that provides user management capabilities with support for multiple data formats (JSON, XML, CSV), batch processing, and REST APIs. The system offers both web-based and API interfaces, integrating MongoDB and PostgreSQL databases for robust data persistence.

This application demonstrates enterprise-level features including user authentication, asynchronous processing, and Apache Camel integration for data transformation. It provides a complete solution for managing user data with support for importing, exporting, and format conversion operations. The system includes batch processing capabilities for handling large datasets and a comprehensive REST API documented with Swagger/OpenAPI.

## Repository Structure
```
.
├── dev_env/                          # Development environment configurations
│   └── sprint-boot-sample/           # Main Spring Boot application
│       ├── src/                      # Source code directory
│       │   └── main/
│       │       ├── java/             # Java source files
│       │       │   └── com/example/demo/
│       │       │       ├── batch/    # Batch processing configurations
│       │       │       ├── camel/    # Apache Camel route definitions
│       │       │       ├── config/   # Application configurations
│       │       │       ├── controller/ # Web and REST controllers
│       │       │       ├── document/ # MongoDB document models
│       │       │       ├── model/    # Domain models
│       │       │       ├── repository/ # Data repositories
│       │       │       └── service/  # Business logic services
│       │       └── resources/        # Application resources and templates
│       ├── pom.xml                   # Maven project configuration
│       └── startup.sh                # Application startup script
└── .devcontainer/                    # Development container configuration
    ├── Dockerfile                    # Container image definition
    └── docker-compose.yml            # Multi-container environment setup
```

## Usage Instructions
### Prerequisites
- Java Development Kit (JDK) 17 or later
- Maven 3.6 or later
- Docker and Docker Compose for running the development environment
- PostgreSQL 13+ (provided via Docker)
- MongoDB 4.4+ (provided via Docker)

### Installation

#### Using Docker Development Environment
1. Clone the repository:
```bash
git clone <repository-url>
cd <repository-name>
```

2. Start the development container:
```bash
cd .devcontainer
docker-compose up -d
```

3. Build and run the application:
```bash
cd dev_env/sprint-boot-sample
./startup.sh
```

#### Manual Installation
1. Install dependencies:
```bash
# Ubuntu/Debian
sudo apt-get update
sudo apt-get install openjdk-17-jdk maven

# macOS
brew install openjdk@17 maven

# Windows
# Install JDK 17 from https://adoptium.net/
# Install Maven from https://maven.apache.org/download.cgi
```

2. Configure databases:
```bash
# Start PostgreSQL
docker run -d --name postgres -e POSTGRES_PASSWORD=password -e POSTGRES_DB=testdb -p 5432:5432 postgres

# Start MongoDB
docker run -d --name mongodb -e MONGO_INITDB_ROOT_USERNAME=mongoadmin -e MONGO_INITDB_ROOT_PASSWORD=mongopassword -p 27017:27017 mongo
```

3. Build and run the application:
```bash
cd dev_env/sprint-boot-sample
mvn clean install
mvn spring-boot:run
```

### Quick Start
1. Access the web interface at `http://localhost:8080`
2. Log in with default credentials:
   - Username: admin
   - Password: admin123
3. Use the web interface to:
   - View and manage users
   - Import users from CSV
   - Export users in different formats
   - Edit user information

### More Detailed Examples

#### REST API Usage
```bash
# Get all users
curl http://localhost:8080/api/users

# Create new user
curl -X POST http://localhost:8080/api/users \
  -H "Content-Type: application/json" \
  -d '{"name":"John Doe","email":"john@example.com"}'

# Export users as CSV
curl http://localhost:8080/api/users/download/csv -o users.csv
```

#### Batch Import Example
```bash
# Import users from CSV file
curl -X POST http://localhost:8080/api/users/import \
  -F "file=@users.csv" \
  -H "Content-Type: multipart/form-data"
```

### Troubleshooting

#### Common Issues

1. Database Connection Issues
```
Error: Unable to connect to PostgreSQL
Solution: 
- Check if PostgreSQL container is running: docker ps
- Verify database credentials in application.properties
- Test connection: psql -h localhost -U postgres -d testdb
```

2. MongoDB Authentication Failures
```
Error: MongoAuthenticationException
Solution:
- Verify MongoDB credentials in application.properties
- Check MongoDB container logs: docker logs mongodb
- Ensure MongoDB is running: docker ps | grep mongodb
```

3. Application Startup Failures
```
Error: Port 8080 already in use
Solution:
- Kill process using port: sudo lsof -i :8080
- Change port in application.properties: server.port=8081
```

#### Debug Mode
Enable debug logging:
1. Add to application.properties:
```properties
logging.level.root=DEBUG
logging.level.com.example.demo=DEBUG
```

2. Run with debug options:
```bash
mvn spring-boot:run -Dspring-boot.run.jvmArguments="-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005"
```

## Data Flow
The application processes user data through multiple layers, supporting various data formats and storage options.

```ascii
[Web UI/REST API] --> [Controllers] --> [Services] --> [Repositories]
       ↑                    ↓             ↓              ↓
       |             [Data Validation] [Format Conv.] [Storage]
       |                    ↓             ↓              ↓
[Thymeleaf Views] <-- [User Objects] --> [MongoDB] --> [PostgreSQL]
```

Key component interactions:
1. Controllers handle HTTP requests and delegate to appropriate services
2. Services implement business logic and data transformation
3. Apache Camel routes handle data format conversions
4. Batch processors manage bulk data operations
5. Multiple repositories provide data persistence options
6. Asynchronous processing handles long-running operations
7. Security layer manages authentication and authorization

## Infrastructure

![Infrastructure diagram](./docs/infra.svg)

### Docker Services
- **devcontainer**: Java 17 development environment
  - Ports: 8080
  - Volumes: workspace, maven cache
  
- **postgresdb**: PostgreSQL database
  - Ports: 5433:5432
  - Environment: POSTGRES_DB=testdb
  
- **mongodb**: MongoDB database
  - Ports: 27017
  - Environment: Authentication enabled
  
- **db2**: IBM DB2 database (optional)
  - Ports: 50000
  - Volumes: database storage

### Development Environment
- VS Code development container with Java extensions
- Maven build system with wrapper
- Zsh shell with developer utilities
- Git configuration and aliases