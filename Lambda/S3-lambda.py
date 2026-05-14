import json
import boto3

s3 = boto3.client('s3')
BUCKET_NAME = "weather-bucket-1111"

def lambda_handler(event, context):
    for record in event['Records']:
        new_image = record['dynamodb']['NewImage']       

        item = {
            "city": new_image['city']['S'],
            "time": new_image['time']['S'],
            "temperature": new_image['temperature']['S'],
            "description": new_image['description']['S']
        }

        file_name = f"{item['city']}_{item['time']}.json"

        s3.put_object(
            Bucket=BUCKET_NAME,
            Key=file_name,
            Body=json.dumps(item)
        )