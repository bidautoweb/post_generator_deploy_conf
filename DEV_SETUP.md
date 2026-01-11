# Development Environment Setup Guide

This guide will help you set up the complete microservices development environment with hot reload capabilities using Docker and Infisical for environment management.

## Prerequisites

1. **Docker & Docker Compose** installed
2. **Infisical CLI** installed (`npm install -g @infisical/cli`)
3. **Make** utility (usually pre-installed on macOS/Linux)
4. **Access to Infisical project** with dev environment configured

## Quick Setup Steps

### 1. Install Infisical CLI

```bash
# Install Infisical CLI
npm install -g @infisical/cli

# Login to Infisical
infisical login
```

### 2. Configure Infisical Environment

Make sure you have access to the Infisical project and the `dev` environment is configured with all necessary variables:

- `OPENAI_API_KEY`
- `TELEGRAM_BOT_TOKEN`
- `TELEGRAM_CHANNEL_ID`
- `SECRET_BOT_POST_GENERATOR_KEY`
- Database credentials (`*_DB_USER`, `*_DB_PASS`, `*_DB_NAME`)
- RabbitMQ credentials (`RABBITMQ_USER`, `RABBITMQ_PASSWORD`)
- Queue names (`*_QUEUE_NAME`, `RABBITMQ_EXCHANGE_NAME`)
- API keys (`AUCTION_API_KEY`)
- Other service configurations

### 3. Start Development Environment

```bash
cd bidauto-ai-post-bot/post_generator_deploy_conf

# Start development environment with hot reload
make dev
```

### 4. Available Make Commands

```bash
# Development commands
make dev                    # Start dev environment with hot reload
make dev-pull              # Pull latest images for dev
make dev-down              # Stop dev environment
make dev-logs              # View logs from all services
make dev-restart           # Restart all services
make dev-rebuild           # Rebuild and restart dev environment
make dev-clean-rebuild     # Clean rebuild with cache clearing

# New volume management commands
make dev-clean-all         # Clean everything including volumes (nuclear option)

# Production commands
make up                    # Start production environment
make down                  # Stop production environment
make logs                  # View production logs
make restart               # Restart production services

# Utility commands
make clean                 # Clean up Docker system and volumes
```

## 🔥 Hot Reload Features

The development environment includes:

✅ **Volume Mounting** - Your local code is mounted into containers  
✅ **Watchdog Integration** - Automatic service restart on code changes  
✅ **Poetry Dependencies** - All Python dependencies properly managed  
✅ **PostgreSQL Databases** - Real databases (not SQLite) for development  
✅ **Full Stack** - All services (DB, RabbitMQ, APIs) running together

### Services with Hot Reload:

- **auction_api_service** - gRPC API service with hot reload (`watch_rpc_server.py`)
- **calculator_service** - Calculator gRPC service with hot reload (`watch_rpc_server.py`)
- **ai_chatbot_service** - AI chatbot service with hot reload (`watch_main.py`)
- **post_generator_service** - Post generation service with hot reload (`watch_main.py`)
- **post_generator_bot** - Telegram bot service with hot reload (`app/main.py`)
- **post_generator_bot_consumer** - Message consumer with hot reload (`watch_consumer.py`)

## 📊 Access Points

- **RabbitMQ Management**: http://localhost:15672 (guest/guest or configured credentials)
- **Adminer (DB Admin)**: http://localhost:8090 (access all PostgreSQL databases)
- **Grafana (Monitoring)**: http://localhost:3000 (admin/admin)
- **PostgreSQL Databases**:
  - `postgres_api` (auction service)
  - `postgres_calculator` (calculator service)
  - `postgres_post_bot` (post generator bot)
  - `postgres_post_service` (post generator service)

## Database Setup

### Initial User Setup for Bot Access

The Telegram bot requires users to be authorized in the database:

1. **Access Adminer**: http://localhost:8090
2. **Connect to `postgres_post_bot`** database
3. **Add your Telegram user** to the appropriate user table
4. **Test bot access** by sending `/start` to the bot

## Testing Your Extension

### 1. Verify Services are Running

```bash
# Check all services status
docker-compose -f docker-compose.dev.yml ps

# Check specific service logs
docker logs post_generator_service_dev -f
docker logs post_generator_bot_consumer_dev -f
docker logs ai_chatbot_service_dev -f
```

### 2. Test the Extension

1. **Load your extension** in Chrome
2. **Navigate to a Manheim listing**
3. **Open the extension popup**
4. **Click "Scrape Current Page"**
5. **Check the Telegram preview** for images and data
6. **Click "Send to Me"** to test the full pipeline

### 3. Monitor Message Flow

Watch the logs to see messages flowing through the system:

```bash
# Watch all services
make dev-logs

# Watch specific services for debugging
docker logs post_generator_service_dev -f
docker logs post_generator_bot_consumer_dev -f
docker logs rabbitmq -f
```

## Development Workflow

### Making Code Changes

1. **Edit code** in any service directory (`*_service/`, `*_bot/`)
2. **Save files** - Services automatically restart via watchdog
3. **Check logs** - `make dev-logs` to see restart messages
4. **Test changes** - Use your extension to test immediately

### Key Development Features

- **Poetry Dependencies**: All services use Poetry for dependency management
- **PostgreSQL**: Real databases instead of SQLite for accurate development
- **Hot Reload**: Watchdog monitors file changes and restarts services
- **Volume Mounting**: Code changes reflect immediately without rebuilds

### Debugging

```bash
# View all service logs
make dev-logs

# Restart specific service
docker restart post_generator_service_dev

# Check RabbitMQ queues and exchanges
# Go to http://localhost:15672

# Check database tables and data
# Go to http://localhost:8090

# Clean restart if issues persist
make dev-clean-all
make dev
```

## Troubleshooting

### Common Issues:

1. **Infisical Not Logged In**:

   ```bash
   infisical login
   ```

2. **Missing Environment Variables**:

   - Check Infisical dev environment has all required vars
   - Verify project ID in Makefile: `178fffd9-36a5-41c7-8c9f-5524ca51dbfd`

3. **Docker Issues**:

   ```bash
   # Clean up and restart
   make dev-down
   make dev-clean-all  # Nuclear option - removes volumes too
   make dev
   ```

4. **Database Migration Issues**:

   ```bash
   # Clean volumes and restart
   make dev-clean-all
   make dev
   ```

5. **RabbitMQ Connection Issues**:

   - Check RabbitMQ is healthy: `docker logs rabbitmq`
   - Verify credentials in Infisical
   - Services will retry connections automatically

6. **Port Conflicts**:

   - Check if ports 5672, 15672, 8090, 3000 are available
   - Stop conflicting services

7. **Missing Python Dependencies**:
   - Dependencies are managed by Poetry in each service
   - Rebuild if needed: `make dev-rebuild`

### Service Architecture

```
Manheim Extension → RabbitMQ → Post Generator Service → Post Generator Bot → Telegram
                                     ↓                        ↓
                              PostgreSQL Database    PostgreSQL Database
                                     ↑
                              Calculator Service ← Auction API Service
                                     ↓                        ↓
                              PostgreSQL Database    PostgreSQL Database
```

## Environment Management

The system uses **Infisical** for secure environment variable management:

- **Production**: `make up` (uses `prod` environment)
- **Development**: `make dev` (uses `dev` environment)
- **Environment variables** are automatically injected by Infisical
- **No local .env files** needed - everything managed centrally
- **DEBUG mode**: Set to `false` in development to use PostgreSQL

## Technical Implementation Details

### Docker Setup

- **Development Dockerfiles**: Each service has `Dockerfile.dev` with Poetry and hot reload
- **Volume Mounting**: Source code mounted for instant changes
- **Poetry Integration**: Dependencies installed via Poetry in containers
- **PostgreSQL**: All services use PostgreSQL databases (not SQLite)

### Hot Reload Implementation

- **Watchdog**: Python file monitoring for automatic restarts
- **Watch Scripts**: Each service has watch scripts (`watch_*.py`)
- **Volume Mounting**: Code changes reflect immediately

### Database Configuration

- **PostgreSQL**: Separate databases for each service
- **Adminer**: Web interface for database management
- **Migrations**: Alembic migrations run automatically on startup

This setup provides a complete development environment with hot reloading, proper database setup, monitoring, and secure configuration management!
