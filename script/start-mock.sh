#!/bin/sh

# Start mock server
docker run -d -p 8080:8080 -p 8081:8081 thiht/smocker:0.18.1
