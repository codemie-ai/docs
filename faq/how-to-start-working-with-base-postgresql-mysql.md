# How to start working with base postgresql mysql? How to integrate postgresql or mysql with CodeMie?

To integrate base with CodeMie, follow the steps below:

1.  In base create user or use existing:
    Creating a User in MySQL:

1.  Log in to MySQL: First, log in to your MySQL server as the root user.

            bash: mysql -u root -p

1.  Create a New User: Once logged in, you can create a new user by executing the following SQL statement. Replace username with the name of the new user, and password with the user's password.

            sql: CREATE USER 'username'@'localhost' IDENTIFIED BY 'password';

1.  Grant Privileges: After creating the user, you need to grant them the necessary privileges. For example, to grant all privileges on all databases:

            sql: GRANT ALL PRIVILEGES ON *.* TO 'username'@'localhost';

1.  Flush Privileges: Finally, flush the MySQL privileges to ensure they are applied.

                 sql: FLUSH PRIVILEGES;

    Creating a User in PostgreSQL:

1.  Log in to PostgreSQL: First, log in to your PostgreSQL database as the superuser, typically postgres.

            bash: sudo -u postgres psql

1.  Create a New User: Use the following command to create a new user. Replace username with the name of the new user.

            sql: CREATE USER username WITH PASSWORD 'password';

1.  Grant Privileges: You can then grant privileges to the user. For example, to grant all privileges on a database to the user:

            sql: GRANT ALL PRIVILEGES ON DATABASE databasename TO username;

1.  Copy your database endpoint URL.
1.  In the CodeMie main menu, click the integrations button.
1.  Select Integration Type: User or Project and click Create
1.  Select the Project Name.
1.  Select the Credential Type: SQL.
1.  Fill in the Alias is a representation of the user setting.
1.  Select the Database Dialect: PostgreSQL, MSSql, MySQL or influxDB
1.  Fill in the Database URL field from step 2. For example: example.com .
1.  Fill in the Database or schema name.
1.  Fill in the Username from step 1.2.
1.  Fill in the Password from step 1.2.
1.  Click Create Integration.
1.  Click +Add Datasource:
1.  Create or edit assistant.
1.  Click Explore Assistant, Click Create Assistant fill in the following parameters::

- Project Name: Select the name of your project.
- Name: Specify the assistant name.
- Description: Specify description.
- System Instructions: Specify system instructions.
- Available tools: Data Management - SQL and select from drop down list Alias of credentials from step 7.

  3.1. Click Create.

Query Example: Get list of tables. Get me 10 rows from table (for example) users.

## Sources

- [Sql](https://docs.codemie.ai/user-guide/tools_integrations/tools/sql)
