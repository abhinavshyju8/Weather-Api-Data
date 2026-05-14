import json
import boto3

s3 = boto3.client('s3')
BUCKET_NAME = "weather-bucket-1111"

def lambda_handler(event, context):
    for record in event['Records']:
