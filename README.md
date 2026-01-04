# Post Generator Deployment Configuration

A Docker Compose configuration for deploying the Post Generator Service with supporting infrastructure including RabbitMQ, Loki, and Promtail for logging.

## Overview

This repository contains the deployment configuration for the Post Generator Service, part of the BidAuto ecosystem. It provides a complete containerized environment with message queuing, logging, and monitoring capabilities for the AI-powered social media post generation service.

## Key Features

- **Docker Compose Setup**: Complete containerized deployment configuration
- **Message Queue**: RabbitMQ integration for asynchronous processing
- **Logging Stack**: Loki and Promtail for centralized log aggregation
- **Secret Management**: Infisical integration for secure configuration
- **Cross-Platform**: Support for macOS and Windows deployment
- **Development Environment**: Separate dev configuration for local development

## Architecture

- **RabbitMQ**: Message broker for post generation requests
- **Loki**: Log aggregation system for centralized logging
- **Promtail**: Log collection agent
- **Infisical**: Secret management and configuration

## Tech Stack

- Docker & Docker Compose
- RabbitMQ for message queuing
- Grafana Loki for log aggregation
- Promtail for log shipping
- Infisical for secret management

## Quick Start

### Prerequisites

1. **Get Secrets Access**

   - Sign up at [Infisical](https://infisical.com/)
   - Contact timadzeletan@gmail.com to be added to the project
   - Install Infisical CLI: https://infisical.com/docs/cli/overview

2. **Login to Infisical**
   ```bash
   infisical login
   ```
   Select EU region when prompted

### Deployment

**For Linux/MacOS:**

```bash
make up
```

**For Windows:**

```powershell
.\run.ps1 up
```

**View all available commands:**

```bash
make help
# or
.\run.ps1 help
```

## Configuration

The deployment uses:

- `docker-compose.yml` - Production configuration
- `docker-compose.dev.yml` - Development environment
- `loki-config.yaml` - Loki logging configuration
- `promtail-config.yaml` - Promtail log collection setup
- `.infisical.json` - Secret management configuration

## Development

This configuration supports the Post Generator Service as part of the larger BidAuto microservices architecture, providing the necessary infrastructure for AI-powered content generation and processing.
