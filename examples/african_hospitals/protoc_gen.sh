#!/bin/sh

# Create generated directory
mkdir -p lib/src/generated/

protoc --dart_out=grpc:lib/src/generated -Iprotos hospitals.proto