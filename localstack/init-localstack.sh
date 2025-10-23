#!/bin/bash
QUEUE_NAME=$SQS_QUEUE_NAME

echo "Creating SQS queue: $QUEUE_NAME..."
awslocal sqs create-queue --queue-name $QUEUE_NAME

if [ $? -eq 0 ]; then
  echo "SQS queue '$QUEUE_NAME' created or already exists."
else
  echo "Error creating SQS queue '$QUEUE_NAME'."
fi
