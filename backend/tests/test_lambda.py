import json
import os
import sys

from unittest.mock import patch, MagicMock

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))

os.environ.update({
    'TABLE_NAME': 'test-table',
    'PARTITION_KEY_NAME': 'id',
    'COUNTER_ID': 'visitor-counter',
    'AWS_DEFAULT_REGION': 'us-east-1'
})

import importlib.util

mock_dynamodb = MagicMock()
with patch('boto3.resource', return_value=mock_dynamodb):
    spec = importlib.util.spec_from_file_location("lambda_module",
        os.path.join(os.path.dirname(__file__), '..', 'lambda.py'))
    lambda_module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(lambda_module)

class TestLambdaHandler:

    @patch.dict(os.environ, {
        'TABLE_NAME': 'test-table',
        'PARTITION_KEY_NAME': 'id',
        'COUNTER_ID': 'visitor-counter'
    })

    @patch.object(lambda_module, 'dynamodb')
    def test_successful_counter_increment(self, mock_dynamodb):
        mock_table = MagicMock()
        mock_dynamodb.Table.return_value = mock_table

        mock_table.update_item.return_value = {
            'Attributes': {
                'CounterValue': 5
            }
        }

        result = lambda_module.lambda_handler({}, {})

        assert result['statusCode'] == 200
        body = json.loads(result['body'])
        assert body['message'] == 'Counter was successfully incremented.'
        assert body['newValue'] == 5
        assert isinstance(body['newValue'], int)

        assert 'headers' in result
        assert 'Access-Control-Allow-Origin' in result['headers']
        assert 'Access-Control-Allow-Headers' in result['headers']
        assert 'Access-Control-Allow-Methods' in result['headers']

        mock_table.update_item.assert_called_once_with(
            Key={'id': 'visitor-counter'},
            UpdateExpression="SET CounterValue = if_not_exists(CounterValue, :start) + :inc",
            ExpressionAttributeValues={':inc': 1, ':start': 0},
            ReturnValues="UPDATED_NEW"
        )

    @patch.object(lambda_module, 'dynamodb')
    def test_dynamodb_exception_returns_500(self, mock_dynamodb):
        mock_table = MagicMock()
        mock_dynamodb.Table.return_value = mock_table
        mock_table.update_item.side_effect = Exception("Connection error")

        result = lambda_module.lambda_handler({}, {})

        assert result['statusCode'] == 500
        body = json.loads(result['body'])
        assert 'error' in body
        assert 'headers' in result
        assert 'Access-Control-Allow-Origin' in result['headers']
        assert 'Access-Control-Allow-Headers' in result['headers']
        assert 'Access-Control-Allow-Methods' in result['headers']

    @patch.object(lambda_module, 'dynamodb')
    def test_missing_attributes_in_response(self, mock_dynamodb):
        mock_table = MagicMock()
        mock_dynamodb.Table.return_value = mock_table
        mock_table.update_item.return_value = {}

        result = lambda_module.lambda_handler({}, {})

        assert result['statusCode'] == 200
        body = json.loads(result['body'])
        assert body['newValue'] is None

    @patch.object(lambda_module, 'dynamodb')
    def test_first_counter_increment_from_zero(self, mock_dynamodb):
            mock_table = MagicMock()
            mock_dynamodb.Table.return_value = mock_table
            mock_table.update_item.return_value = {
                'Attributes' : {'CounterValue' : 1}
            }

            result = lambda_module.lambda_handler({}, {})

            assert result['statusCode'] == 200
            body = json.loads(result['body'])
            assert body['newValue'] == 1

    @patch.object(lambda_module, 'TABLE_NAME', None)
    @patch.object(lambda_module, 'dynamodb')
    def test_missing_env_vars_returns_500(self, mock_dynamodb):
        mock_table = MagicMock()
        mock_dynamodb.Table.return_value = mock_table

        result = lambda_module.lambda_handler({}, {})

        assert result['statusCode'] == 500
        body = json.loads(result['body'])
        assert body['error'] == 'Missing required environment variables'