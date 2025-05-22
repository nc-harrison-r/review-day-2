import pytest
from fastapi.testclient import TestClient
from api.app import app

def test_handle_healthcheck():
    client = TestClient(app)
    response = client.get("/healthcheck")
    assert response.status_code == 200
    assert response.json() == {"message": "Server is running!"}

def test_handle_doughnuts_info():
    client = TestClient(app)
    response = client.get("/doughnuts/info")
    assert response.status_code == 200
    assert response.json() == {
	"doughnuts": [
		{
			"doughnut_type": "Choccy Delight",
			"price": 1.38,
			"calories": 800,
			"contains_nuts": True
		},
		{
			"doughnut_type": "Strawberry Haze",
			"price": 2.42,
			"calories": 900,
			"contains_nuts": True
		},
		{
			"doughnut_type": "Sprinkly Bonanza",
			"price": 1.97,
			"calories": 1000,
			"contains_nuts": True
		},
		{
			"doughnut_type": "Nutty Heaven",
			"price": 1.27,
			"calories": 700,
			"contains_nuts": False
		},
		{
			"doughnut_type": "Caramel Caress",
			"price": 1.45,
			"calories": 750,
			"contains_nuts": False
		},
		{
			"doughnut_type": "Delectable Delights",
			"price": 2.75,
			"calories": 300,
			"contains_nuts": False
		},
		{
			"doughnut_type": "Banana Bonanza",
			"price": 1.87,
			"calories": 585,
			"contains_nuts": False
		},
		{
			"doughnut_type": "Marshmallow Marsh",
			"price": 1.65,
			"calories": 788,
			"contains_nuts": True
		},
		{
			"doughnut_type": "Rocky Road",
			"price": 2.22,
			"calories": 999,
			"contains_nuts": True
		},
		{
			"doughnut_type": "Biscoff Gourmet",
			"price": 1.46,
			"calories": 692,
			"contains_nuts": False
		}
	]
}
def test_handle_doughnuts_info_max_calorie_query():
    client = TestClient(app)
    response = client.get("/doughnuts/info?max_calories=600")
    assert response.status_code == 200
    assert response.json() == {
	"doughnuts": [
		{
			"doughnut_type": "Delectable Delights",
			"price": 2.75,
			"calories": 300,
			"contains_nuts": False
		},
		{
			"doughnut_type": "Banana Bonanza",
			"price": 1.87,
			"calories": 585,
			"contains_nuts": False
		}
	]
}

def test_handle_doughnuts_info_allow_nuts_query():
    client = TestClient(app)
    response = client.get("/doughnuts/info?allow_nuts=false")
    assert response.status_code == 200
    assert response.json() == {
	"doughnuts": [
		{
			"doughnut_type": "Nutty Heaven",
			"price": 1.27,
			"calories": 700,
			"contains_nuts": False
		},
		{
			"doughnut_type": "Caramel Caress",
			"price": 1.45,
			"calories": 750,
			"contains_nuts": False
		},
		{
			"doughnut_type": "Delectable Delights",
			"price": 2.75,
			"calories": 300,
			"contains_nuts": False
		},
		{
			"doughnut_type": "Banana Bonanza",
			"price": 1.87,
			"calories": 585,
			"contains_nuts": False
		},
		{
			"doughnut_type": "Biscoff Gourmet",
			"price": 1.46,
			"calories": 692,
			"contains_nuts": False
		}
	]
}

def test_handle_doughnuts_info_calorie_and_allow_nuts():
    client = TestClient(app)
    response = client.get("/doughnuts/info?max_calories=600&allow_nuts=false")
    assert response.status_code == 200
    assert response.json() == {
    "doughnuts": [
        {
            "doughnut_type": "Delectable Delights",
            "price": 2.75,
            "calories": 300,
            "contains_nuts": False
        },
        {
            "doughnut_type": "Banana Bonanza",
            "price": 1.87,
            "calories": 585,
            "contains_nuts": False
        }
    ]
}

def test_handle_doughnuts_info_invalid_max_calories():
    client = TestClient(app)
    response = client.get("/doughnuts/info?max_calories=abc")
    assert response.status_code == 422
    assert response.json() == {
	"detail": [
		{
			"type": "int_parsing",
			"loc": [
				"query",
				"max_calories"
			],
			"msg": "Input should be a valid integer, unable to parse string as an integer",
			"input": "abc"
		}
	]
}

def test_handle_doughnuts_info_invalid_allow_nuts():
    client = TestClient(app)
    response = client.get("/doughnuts/info?allow_nuts=7")
    assert response.status_code == 422
    assert response.json() == {
	"detail": [
		{
			"type": "bool_parsing",
			"loc": [
				"query",
				"allow_nuts"
			],
			"msg": "Input should be a valid boolean, unable to interpret input",
			"input": "7"
		}
	]
}

def test_handle_doughnuts_info_invalid_combination():
    client = TestClient(app)
    response = client.get("/doughnuts/info?max_calories=10&allow_nuts=invalid_value")
    assert response.status_code == 422
    assert response.json() == {
	"detail": [
		{
			"type": "bool_parsing",
			"loc": [
				"query",
				"allow_nuts"
			],
			"msg": "Input should be a valid boolean, unable to interpret input",
			"input": "invalid_value"
		}
	]
}

def test_handle_doughnuts_info_no_matching_results():
    client = TestClient(app)
    response = client.get("/doughnuts/info?max_calories")
    assert response.status_code == 422
    assert response.json() == {
	"detail": [
		{
			"type": "int_parsing",
			"loc": [
				"query",
				"max_calories"
			],
			"msg": "Input should be a valid integer, unable to parse string as an integer",
			"input": ""
		}
	]
}

def test_handle_doughnuts_info_no_matching_results():
    client = TestClient(app)
    response = client.get("/doughnuts/info?max_calories=100&allow_nuts=false")
    assert response.status_code == 200
    assert response.json() == {"doughnuts": []}

def test_handle_doughnuts_invalid_endpoint():
    client = TestClient(app)
    response = client.get("/doughnuts/invalid_info")
    assert response.status_code == 404
    assert response.json() == {"detail": "Not Found"}