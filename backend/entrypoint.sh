#!/bin/bash

echo "Subindo FastAPI..."
exec uvicorn app.main:app --host 0.0.0.0 --port 8000