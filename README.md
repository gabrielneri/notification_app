# Notification App

> A notification service with asynchronous delivery and multiple channels.

**API Documentation:** https://api.gabrielneri.com/api-docs

## Overview

This project exposes an HTTP API for creating notifications.

The API handles requests synchronously, while notification delivery
is processed asynchronously by background workers.

The system supports multiple notification channels such as **email**,
**SMS**, **Telegram** and **Discord**.

**Important:** SMS delivery is currently **simulated**.
No real SMS messages are sent.

## Features

- Create notifications via HTTP API
- Asynchronous notification delivery
- Multiple delivery channels:
  - Email (via Resend)
  - SMS (simulated)
  - Telegram (chat ID required)
  - Discord (webhook URL required)

## Architecture

The system is structured in clear responsibility-based layers.
HTTP handling, background processing, orchestration, and delivery
are intentionally separated.

### Architecture Layers

```
┌──────────────────────────────────────────────────┐
│  API Layer                                       │
│  - Handle HTTP requests                          │
│  - Persist notification data                     │
│  - Enqueue background jobs                       │
│                                                  │  
│  This layer is synchronous and contains no       │
│  delivery logic.                                 │
└──────────────────────────────────────────────────┘
                      ↓
┌──────────────────────────────────────────────────┐
│  Worker Layer                                    │
│  - Consume messages from the queue               │
│  - Load persisted notifications                  │
│  - Delegate execution to the service layer       │
│                                                  │
│  Workers are intentionally thin and do not       │
│  contain channel-specific logic.                 │
└──────────────────────────────────────────────────┘
                      ↓
┌──────────────────────────────────────────────────┐
│  Service (Orchestration) Layer                   │
│  - Decide how a notification should be delivered │
│  - Route notifications to the appropriate channel│
│                                                  │
│  This layer centralizes delivery decisions and   │
│  keeps orchestration logic out of workers and    │
│  controllers.                                    │
└──────────────────────────────────────────────────┘
                      ↓
┌──────────────────────────────────────────────────┐
│  Channel Layer                                   │
│  - Deliver notifications through a specific      │
│    channel                                       │
│  - Integrate with external providers when        │
│    applicable                                    │
│                                                  │
│  Each channel is implemented independently and   │
│  shares a common interface, making the system    │
│  easy to extend.                                 │
└──────────────────────────────────────────────────┘
```

## Structure

```
app/
├── controllers/        # API layer
├── models/             # Data model and persistence
├── services/           # Notification orchestration
│   └── channels/       # Channel-specific delivery implementations
├── workers/            # Background job execution
├── mailers/            # Email infrastructure
```

## Testing

The project includes automated tests covering the main execution paths,
including HTTP API requests, background workers, service orchestration,
and channel-specific delivery logic.

Tests are written using RSpec.

## API Documentation

The HTTP API is documented using OpenAPI.

The specification describes available endpoints, request and response
formats, and validation rules.

## License

MIT