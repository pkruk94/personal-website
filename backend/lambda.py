import json
import boto3
import os

dynamodb = boto3.resource('dynamodb')
TABLE_NAME = os.environ.get('TABLE_NAME')
PARTITION_KEY_NAME = os.environ.get('PARTITION_KEY_NAME')
COUNTER_ID = os.environ.get('COUNTER_ID')

def lambda_handler(event, context):
    table = dynamodb.Table(TABLE_NAME)

    try:
        response = table.update_item(
            Key={
                PARTITION_KEY_NAME: COUNTER_ID
            },
            UpdateExpression="SET CounterValue = if_not_exists(CounterValue, :start) + :inc",
            ExpressionAttributeValues={':inc': 1,':start': 0},
            ReturnValues="UPDATED_NEW"
        )
        new_value = response.get('Attributes', {}).get('CounterValue')

        return {
            'statusCode': 200,
            'body': json.dumps({
                'message': 'Counter was successfully incremented.',
                'newValue': new_value
            })
        }
    except Exception as e:
        print(f"Error occurred: {e}")
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }