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

-- Create Table
CREATE OR REPLACE TABLE weather_table (
    data VARIANT
);

-- Load Existing Files into Table
COPY INTO weather_table(data)
FROM (
    SELECT $1
    FROM @my_stage
)
FILE_FORMAT = (TYPE = 'JSON');

-- View Raw JSON
SELECT data
FROM weather_table
LIMIT 1;

-- Query JSON Fields
SELECT
    data:city::STRING AS city,
    data:temperature::FLOAT AS temperature,
    data:humidity::INTEGER AS humidity,
    data:weather::STRING AS weather,
    data:time::TIMESTAMP AS weather_time
FROM weather_table;

-- Create Snowpipe for Auto Ingest
CREATE OR REPLACE PIPE weather_pipe
AUTO_INGEST = FALSE
AS
COPY INTO weather_table(data)
FROM (
    SELECT $1
    FROM @my_stage
)
FILE_FORMAT = (TYPE = 'JSON');

-- Check Copy History
SELECT *
FROM TABLE(
    INFORMATION_SCHEMA.COPY_HISTORY(
        TABLE_NAME => 'WEATHER_TABLE',
        START_TIME => DATEADD(HOURS, -1, CURRENT_TIMESTAMP())
    )
);