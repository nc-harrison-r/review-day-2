"""Lambda handler to get quotes and write them to S3."""

import requests
import boto3
import os
import json
import boto3
from botocore.exceptions import ClientError
import logging
from datetime import datetime as dt
from random import random, randint

logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)


BUCKET_NAME = os.environ["S3_BUCKET_NAME"]
URL = "https://zenquotes.io/api/random/"


def lambda_handler(event, context):
    """Main handler - event is empty."""
    try:
        s3_client = boto3.client("s3")
        output_data = {"quotes": []}
        timestamp = str(int(dt.timestamp(dt.now())))
        quotes = [get_quote() for _ in range(3)]
        output_data["quotes"] = [resp for status, resp in quotes if status == 200]
        if random() < 0.1:
            quote = output_data["quotes"][randint(0, 2)]
            content = quote["content"]
            logger.info("[GREAT QUOTE] %s", content)
        key = f"quote_{timestamp}.json"
        write_result = write_to_s3(s3_client, output_data, BUCKET_NAME, key)
        if write_result:
            logger.info("Wrote quotes to S3")
        else:
            logger.info("There was a problem. Quotes not written.")
    except Exception as e:
        logger.info(f"Unexpected Exception: %s", str(e))


def get_quote(url=URL):
    """Helper to get quote from external API."""
    try:
        response = requests.get(url, timeout=5)
        response.raise_for_status()
        raw = response.json()
        if (
            raw[0]["q"]
            == "Unrecognized API request. Visit zenquotes.io for documentation."
        ):
            response.status_code = 404
            raise requests.exceptions.HTTPError(raw[0])
        required = ["q", "a"]
        quote = {k: raw[0][k] for k in required}
        formatted_quote = {
            "content": quote["q"],
            "author": quote["a"],
            "length": len(quote["q"]),
        }
        return (response.status_code, formatted_quote)
    except requests.exceptions.HTTPError as h:
        logger.error("HTTP Status %s: %s", response.status_code, str(h))
        formatted = {"status_message": response.json()[0]}
        return (response.status_code, formatted)


def write_to_s3(client, data, bucket, key):
    """Helper to write material to S3."""
    body = json.dumps(data)
    try:
        client.put_object(Bucket=bucket, Key=key, Body=body)
        return True
    except ClientError as c:
        logger.info("Boto3 ClientError: %s", str(c))
        return False
