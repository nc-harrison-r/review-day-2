from fastapi import FastAPI
import json
import os

#make venv, export pythonpath, install pytest and run pip install "fastapi[standard]"

app = FastAPI()

@app.get("/healthcheck")
def handle_healthcheck():
    return {"message": "Server is running!"}

@app.get("/doughnuts/info")
def handle_doughnuts_info(max_calories: int = 1001, allow_nuts: bool = True):
    doughnuts = {}
    with open(os.path.join(os.path.dirname(__file__), "..", "data", "doughnuts.json"), "r") as f:
        data = json.load(f)
        doughnuts = data["doughnut_data"]
    
    filtered_doughnuts = [doughnut for doughnut in doughnuts if doughnut["calories"] <= max_calories]

    if not allow_nuts:
        filtered_doughnuts = [doughnut for doughnut in filtered_doughnuts if not doughnut["contains_nuts"]]
    
    return {"doughnuts": filtered_doughnuts}