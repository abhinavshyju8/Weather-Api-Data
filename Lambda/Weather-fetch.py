import json
import urllib.request
import boto3
from datetime import datetime

def lambda_handler(event, context):

    api_key = "04c20c5de85f796888612a01e8d749d9"
    city = "Kozhikode"