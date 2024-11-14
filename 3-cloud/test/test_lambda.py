import os
import logging
import json
from unittest.mock import Mock, patch

import pytest
import boto3
from freezegun import freeze_time
from moto import mock_aws
from requests import Response

with patch.dict(os.environ, {"S3_BUCKET_NAME": "test_bucket"}):
    from src.quotes import get_quote, URL, write_to_s3, lambda_handler, ZEN_QUOTES_404


class DummyContext:
    pass


@pytest.fixture(scope="function")
def aws_credentials():
    """Mocked AWS Credentials for moto."""
    os.environ["AWS_ACCESS_KEY_ID"] = "test"
    os.environ["AWS_SECRET_ACCESS_KEY"] = "test"
    os.environ["AWS_SECURITY_TOKEN"] = "test"
    os.environ["AWS_SESSION_TOKEN"] = "test"
    os.environ["AWS_DEFAULT_REGION"] = "eu-west-2"


@pytest.fixture(scope="function")
def s3(aws_credentials):
    with mock_aws():
        yield boto3.client("s3", region_name="eu-west-2")


@pytest.fixture
def bucket(s3):
    s3.create_bucket(
        Bucket="test_bucket",
        CreateBucketConfiguration={"LocationConstraint": "eu-west-2"},
    )


quotes = [
    {
        "q": "It matters not what someone is born, but what they grow to be.",
        "a": "Albus Dumbledore",
        "h": "<blockquote>&ldquo;It matters not what someone is born, but what they grow to be.&rdquo; &mdash; <footer>Albus Dumbledore</footer></blockquote>",
    },
    {
        "q": "The unthankful heart discovers no mercies; but the thankful heart will find, in every hour, some heavenly blessings.",
        "a": "Henry Ward Beecher",
        "h": "<blockquote>&ldquo;The unthankful heart discovers no mercies; but the thankful heart will find, in every hour, some heavenly blessings.&rdquo; &mdash; <footer>Henry Ward Beecher</footer></blockquote>",
    },
    {
        "q": "Be thankful for what you have; you'll end up having more. If you concentrate on what you don't have, you will never, ever have enough. ",
        "a": "Oprah Winfrey",
        "h": "<blockquote>&ldquo;Be thankful for what you have; you'll end up having more. If you concentrate on what you don't have, you will never, ever have enough. &rdquo; &mdash; <footer>Oprah Winfrey</footer></blockquote>",
    },
]

processed = {
    "content": "It matters not what someone is born, but what they grow to be.",
    "author": "Albus Dumbledore",
    "length": 62,
}


class TestGetQuote:
    """Tests the get_quote helper."""

    @pytest.mark.it("unit test: get_quote returns correctly formatted dict")
    def test_get_quote_dict(self):
        mock_response = Mock(spec=Response, status_code=200)
        with patch("src.quotes.requests.get") as mock_request:
            mock_request.return_value = mock_response
            mock_response.json.return_value = quotes[0:1]
            assert get_quote() == (200, processed)

    @pytest.mark.it("unit test: get_quote calls correct url")
    def test_get_quote_url(self):
        with patch("src.quotes.requests.get") as mock_request:
            get_quote()
            mock_request.assert_called_once_with(URL, timeout=5)

    @pytest.mark.it("integration test: get_quote gets valid url")
    def test_get_quote_valid_url(self):
        status_code, _ = get_quote()
        assert status_code == 200

    @pytest.mark.it("unit test: returns correct message if non 200 response")
    def test_get_quote_error_response(self):
        status_code, response = get_quote(url="https://zenquotes.io/api/wibble/wobble")
        assert status_code == 404
        assert response == {"status_message": ZEN_QUOTES_404}

    @pytest.mark.it("unit test: get_quote logs error")
    def test_get_quote_error_log(self, caplog):
        with caplog.at_level(logging.INFO):
            get_quote(url="https://zenquotes.io/api/wibble/wobble")
            assert "HTTP Status 404" in caplog.text


class TestWriteToS3:
    """Tests the write_to_s3 helper."""

    @pytest.mark.it("unit test write_to_s3 puts file")
    def test_write_to_s3(self, s3, bucket):
        key = "test_file.json"
        data = [{"a": 1}, {"b": 2}]
        resp = write_to_s3(s3, data, "test_bucket", key)
        listing = s3.list_objects_v2(Bucket="test_bucket")
        assert len(listing["Contents"]) == 1
        assert listing["Contents"][0]["Key"] == "test_file.json"
        assert resp

    @pytest.mark.it("unit test: logs client error")
    def test_write_s3_logs_client_error(self, s3, bucket, caplog):
        key = "test_file.json"
        data = [{"a": 1}, {"b": 2}]
        with caplog.at_level(logging.INFO):
            resp = write_to_s3(s3, data, "test_bucket2", key)
            assert not resp
            assert "ClientError" in caplog.text


class TestHandler:
    """Tests the lambda handler"""

    @pytest.mark.it("unit test: writes to s3")
    @patch("src.quotes.get_quote")
    def test_handler_writes_quotes_to_s3(self, mock_quote, s3, bucket, caplog):
        mock_quote.return_value = (200, processed)
        event = {}
        context = DummyContext()
        with caplog.at_level(logging.INFO):
            lambda_handler(event, context)
            assert "Wrote quotes to S3" in caplog.text

    @pytest.mark.it("unit test: writes partial to s3")
    @freeze_time("2024-04-01 12:00")
    @patch("src.quotes.get_quote")
    def test_handler_writes_quotes_to_s3_partial(self, mock_quote, s3, bucket, caplog):
        mock_quote.side_effect = zip([200, 200, 404], [processed] * 3)
        event = {}
        context = DummyContext()
        with caplog.at_level(logging.INFO):
            lambda_handler(event, context)
            expected_key = f"quote_1711972800.json"
            obj = s3.get_object(Bucket="test_bucket", Key=expected_key)["Body"]
            expected = {"quotes": [processed, processed]}
            assert json.loads(obj.read()) == expected
            assert "Wrote quotes to S3" in caplog.text

    @pytest.mark.it("unit test: handles ClientError")
    @patch("src.quotes.write_to_s3")
    @patch("src.quotes.get_quote")
    def test_handler_handles_client_error(
        self, mock_quote, mock_write, s3, bucket, caplog
    ):
        mock_quote.side_effect = zip([200] * 3, [processed] * 3)
        mock_write.return_value = False
        event = {}
        context = DummyContext()
        with caplog.at_level(logging.INFO):
            lambda_handler(event, context)
            assert "There was a problem. Quotes not written." in caplog.text

    @pytest.mark.it("unit test: handles unexpected Exception")
    @patch("src.quotes.get_quote")
    def test_handler_handles_unexpected(self, mock_quote, s3, bucket, caplog):
        mock_quote.side_effect = ArithmeticError
        event = {}
        context = DummyContext()
        with caplog.at_level(logging.INFO):
            lambda_handler(event, context)
            assert "Unexpected Exception: " in caplog.text

    @pytest.mark.it("unit test: flags great quotes")
    @patch("src.quotes.get_quote")
    @patch("src.quotes.random", return_value=0.05)
    def test_flags_great_quotes(self, mock_random, mock_quote, s3, bucket, caplog):
        mock_quote.side_effect = zip([200] * 3, [processed] * 3)
        event = {}
        context = DummyContext()
        with caplog.at_level(logging.INFO):
            lambda_handler(event, context)
            assert "[GREAT QUOTE]" in caplog.text
