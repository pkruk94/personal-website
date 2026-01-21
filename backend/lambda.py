import json
import boto3
import os

from decimal import Decimal

dynamodb = boto3.resource('dynamodb')
TABLE_NAME = os.environ.get('TABLE_NAME')
PARTITION_KEY_NAME = os.environ.get('PARTITION_KEY_NAME')
COUNTER_ID = os.environ.get('COUNTER_ID')
ALLOWED_ORIGIN = os.environ.get('ALLOWED_ORIGIN', '*')

CORS_HEADERS = {
    'Access-Control-Allow-Origin': ALLOWED_ORIGIN,
    'Access-Control-Allow-Headers': 'Content-Type',
    'Access-Control-Allow-Methods': 'GET, POST, OPTIONS'
}

def lambda_handler(event, context):
    if not all([TABLE_NAME, PARTITION_KEY_NAME, COUNTER_ID]):
        return {
            'statusCode': 500,
            'body': json.dumps({'error': 'Missing required environment variables'}),
            'headers': CORS_HEADERS
        }

    table = dynamodb.Table(TABLE_NAME)

    try:
        response = table.update_item(
            Key={
                PARTITION_KEY_NAME: COUNTER_ID
            },
            UpdateExpression="SET CounterValue = if_not_exists(CounterValue, :start) + :inc", # TODO counter value? Co to jest? Moze to sparametryzowac?
            ExpressionAttributeValues={':inc': 1,':start': 0},
            ReturnValues="UPDATED_NEW"
        )
        new_value = response.get('Attributes', {}).get('CounterValue')

        if isinstance(new_value, Decimal):
            new_value = int(new_value)

        return {
            'statusCode': 200,
            'headers': CORS_HEADERS,
            'body': json.dumps({
                'message': 'Counter was successfully incremented.',
                'newValue': new_value
            })
        }
    except Exception as e:
        print(f"Error occurred: {e}")
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)}),
            'headers': CORS_HEADERS
        }