# Data and SQL

Your task in this section will be to connect to the `toy` database and run some queries on the remote database using the credentials provided.

You can do this by setting an environment variable in your terminal like this:

```bash
export PGPASSWORD="DATABASE_PASSWORD_HERE"
```

You will need to run a command like the one show in the template below to run SQL queries on the remote database.

```bash
psql -h "HOST_URL" -p 5432 -U "USERNAME" -d "DATABASE_NAME" -f 1-data/queries.sql
```

In the **queries.sql** file write SQL queries to find the following information from the database:

1. What are the top three products by **number of items sold**? You need to provide the product names and the sales numbers for each.

2. What are the top three products by **monetary value**? You need to provide the product names and the total value of sales for each.

3. Which user was the top spender in December 2022? Provide their email address and phone number.

When you run the queries you should save your results to a separate text file, you can do this with the redirection (`>`) operator like so:

```bash
psql -h "HOST_URL" -p 5432 -U "USERNAME" -d "DATABASE_NAME" -f 1-data/queries.sql > query_output.txt
```

Commit your results and the completed queries, and push them to your GitHub repository.

## Notes and hints

The columns in this database are _very_ badly named. This might cause
you problems.

The ERD for this database is shown.

![image](./ERD.png)
