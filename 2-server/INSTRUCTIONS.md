# Servers

In this section, you will demonstrate that you know how to deploy a simple server.

The `data` folder contains a file of `json` formatted doughnut data. 

## Write an API to provide the following endpoints:

### `/healthcheck`
a simple healthcheck endpoint that returns a 200 response if the server is running.

---

### `/doughnuts/info?max_calories={max_calories}&allow_nuts={contains_nuts}`
 
This should allow users to query:
- `max_calories` _int_:   doughnuts with a maximum number of calories
- `allow_nuts` _bool_:   
  - `False` retrieves doughnuts with _no nuts_ within any other search constraints - nuts are not allowed
  - `True` retrives _all_ doughnuts within any other search constraints - nuts are allowed
  
  Return the `doughnut_type` and price in `json` format. For
  example:
  ```
  GET /doughnuts/info?max_calories=700&allow_nuts=true
  ```
  should return:
  ```json
  {
    "results": [
      { "doughnut_type": "Nutty Heaven", "price": 1.27 },
      { "doughnut_type": "Delectable Delights", "price": 2.75 },
      { "doughnut_type": "Banana Bonanza", "price": 1.87 },
      { "doughnut_type": "Biscoff Gourmet", "price": 1.46 }
    ]
  }
  ```
  If there are no doughnuts that satisfy the criteria, respond with a **204 status code and no body**.

--- 

Your code should be thoroughly tested and served on `localhost`, port 8888.

## Notes:

1. There is no requirement to connect to a database - all the data is stored in a local `json` file. Think about how you're going to access this file from your server.
2. Use a separate Python virtual environment located in this directory.

---

Commit and push your code when you are finished.

Please submit your code for review using the `/nchelp review` slack command.
