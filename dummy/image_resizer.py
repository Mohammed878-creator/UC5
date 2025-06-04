import os
import boto3
from PIL import Image
import io
from urllib.parse import unquote_plus

s3_client = boto3.client('s3')
sns_client = boto3.client('sns')

def lambda_handler(event, context):
    # Get environment variables
    destination_bucket = os.environ['DESTINATION_BUCKET']
    sns_topic_arn = os.environ['SNS_TOPIC_ARN']
    resized_width = int(os.environ['RESIZED_WIDTH'])
    resized_height = int(os.environ['RESIZED_HEIGHT'])
    
    # Process each record in the event
    for record in event['Records']:
        source_bucket = record['s3']['bucket']['name']
        key = unquote_plus(record['s3']['object']['key'])
        
        try:
            # Get the image from S3
            response = s3_client.get_object(Bucket=source_bucket, Key=key)
            image_content = response['Body'].read()
            
            # Resize the image
            image = Image.open(io.BytesIO(image_content))
            image.thumbnail((resized_width, resized_height))
            
            # Save resized image to bytes
            buffer = io.BytesIO()
            image.save(buffer, format=image.format)
            buffer.seek(0)
            
            # Upload resized image to destination bucket
            destination_key = f"resized/{key}"
            s3_client.put_object(
                Bucket=destination_bucket,
                Key=destination_key,
                Body=buffer,
                ContentType=response['ContentType']
            )
            
            # Send success notification
            message = f"Successfully resized {key} and saved to {destination_bucket}/{destination_key}"
            sns_client.publish(
                TopicArn=sns_topic_arn,
                Message=message,
                Subject="Image Resizing Success"
            )
            
        except Exception as e:
            # Send error notification
            error_message = f"Error processing {key}: {str(e)}"
            sns_client.publish(
                TopicArn=sns_topic_arn,
                Message=error_message,
                Subject="Image Resizing Error"
            )
            raise e
    
    return {
        'statusCode': 200,
        'body': 'Image processing completed'
    }
