import json
import urllib.request
import boto3
from datetime import datetime

def lambda_handler(event, context):

    api_key = "04c20c5de85f796888612a01e8d749d9"
    city = "Kozhikode"

    url = f"https://api.openweathermap.org/data/2.5/weather?q={city}&appid={api_key}&units=metric"

    response = urllib.request.urlopen(url)
    data = json.loads(response.read())

    print(data)  # DEBUG (very important)

    # Check if API failed
    if "main" not in data:
        return {
            "statusCode": 400,
            "body": json.dumps(data)
        }
    
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table('weather-db')

    item = {
        "city": city,
        "time": datetime.now().isoformat(),
        "temperature": str(data["main"]["temp"]),
        "description": data["weather"][0]["description"]
    }