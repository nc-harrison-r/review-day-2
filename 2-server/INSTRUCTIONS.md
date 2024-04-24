# Servers

In this section, you will demonstrate that you know how to deploy a simple server.

The `data` folder contains a file of `json` formatted doughnut data. Write an API to provide the following endpoints:

- `/healthcheck` - a simple healthcheck endpoint that returns a 200 response if the server is running.
- `/doughnuts/info?max_calories={max_calories}&nuts={contains_nuts}`
  This should allow users to query doughnuts with a maximum number of calories and specify whether or
  not they _may_ contain nuts (but might not). Return the `doughnut_type` and price in `json` format. For
  example:
  ```
  GET /doughnuts/info?max_calories=700&nuts=true
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

Your code should be thoroughly tested and served on `localhost`, port 8888.

Notes:

1. There is no requirement to connect to a database. All the data is stored in a local `json` file, think about how you're going to access this file from your server.
2. Use a separate Python virtual environment located in this directory.

Commit and push your code when you are finished.

Please submit your code for review using the `/nchelp review` slack command.
