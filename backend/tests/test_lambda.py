import json
import pytest
from unittest.mock import patch, MagicMock
import os
import sys

# Add the parent directory to the path so we can import lambda module
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))

# We need to set environment variables before importing the lambda module
os.environ.update({
    'TABLE_NAME': 'test-table',
    'PARTITION_KEY_NAME': 'id',
    'COUNTER_ID': 'visitor-counter'
})

# Import the lambda module (since 'lambda' is a reserved keyword, we need to be careful)
import importlib.util
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
        """Test successful counter increment and return new value"""
        # Arrange - Set up mocks
        mock_table = MagicMock()
        mock_dynamodb.Table.return_value = mock_table

        # Mock the DynamoDB response
        mock_table.update_item.return_value = {
            'Attributes': {
                'CounterValue': 5
            }
        }

        # Act - Call the function
        result = lambda_module.lambda_handler({}, {})

        # Assert - Check the results
        assert result['statusCode'] == 200

        body = json.loads(result['body'])
        assert body['message'] == 'Counter was successfully incremented.'
        assert body['newValue'] == 5

        # Verify DynamoDB was called correctly
        mock_table.update_item.assert_called_once_with(
            Key={'id': 'visitor-counter'},
            UpdateExpression="SET CounterValue = if_not_exists(CounterValue, :start) + :inc",
            ExpressionAttributeValues={':inc': 1, ':start': 0},
            ReturnValues="UPDATED_NEW"
        )