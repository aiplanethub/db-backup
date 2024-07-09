#!/bin/sh

# Exit immediately if a command exits with a non-zero status.
set -e

# Check if all required environment variables are set
: "${AWS_ACCESS_KEY_ID:?Need to set AWS_ACCESS_KEY_ID}"
: "${AWS_SECRET_ACCESS_KEY:?Need to set AWS_SECRET_ACCESS_KEY}"
: "${AWS_REGION:?Need to set AWS_REGION}"
: "${BUCKET_NAME:?Need to set BUCKET_NAME}"
: "${BACKUP_FILE:?Need to set BACKUP_FILE}"
: "${POSTGRES_HOST:?Need to set POSTGRES_HOST}"
: "${POSTGRES_USER:?Need to set POSTGRES_USER}"
: "${POSTGRES_PASSWORD:?Need to set POSTGRES_PASSWORD}"
: "${POSTGRES_DB:?Need to set POSTGRES_DB}"


# Configure AWS CLI
aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
aws configure set default.region $AWS_REGION

# Download the backup file from S3
aws s3 cp s3://$BUCKET_NAME/$BACKUP_FILE /backup_file.dump

# Restore the backup to the PostgreSQL database
PGPASSWORD=$POSTGRES_PASSWORD pg_restore -h $POSTGRES_HOST -U $POSTGRES_USER -d $POSTGRES_DB /backup_file.dump
