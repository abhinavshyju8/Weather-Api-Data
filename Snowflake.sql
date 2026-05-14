CREATE OR REPLACE FILE FORMAT weather_json
TYPE = 'JSON';

CREATE OR REPLACE STAGE my_stage
URL = 's3://weather-bucket-1111/'
CREDENTIALS = (
    AWS_KEY_ID = os.getenv('AWS_KEY_ID'),
    AWS_SECRET_KEY = os.getenv('AWS_SECRET_KEY')
)
FILE_FORMAT = weather_json;

list @my_stage;
