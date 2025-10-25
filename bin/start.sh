#!/bin/bash

set -e

echo "Starting the application..."
echo "Environment: ${ENV:-development}"

mix ecto.reset
mix phx.server
echo "Application started successfully!" 