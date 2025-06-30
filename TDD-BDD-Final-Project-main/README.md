# TDD / BDD Final Project Template

This repository contains the template to be used for the Final Project for the Coursera course **Introduction to TDD/BDD**.

## Usage

This repository is to be used as a template to create your own repository in your own GitHub account. No need to Fork it as it has been set up as a Template. This will avoid confusion when making Pull Requests in the future.

From the GitHub **Code** page, press the green **Use this template** button to create your own repository from this template. 

Name your repo: `tdd-bdd-final-project`.

## Setup

After entering the lab environment you will need to run the `setup.sh` script in the `./bin` folder to install the prerequisite software.

```bash
bash bin/setup.sh
```

Then you must exit the shell and start a new one for the Python virtual environment to be activated.

```bash
exit
```

## Tasks

In this project you will use good Test Driven Development (TDD) and Behavior Driven Development (BDD) techniques to write TDD test cases, BDD scenarios, and code, updating the following files:

```bash
tests/test_models.py
tests/test_routes.py
service/routes.py
features/products.feature
features/steps/load_steps.py
```

You will be given partial implementations in each of these files to get you started. Use those implementations as examples of the code you should write.

## License

Licensed under the Apache License. See [LICENSE](/LICENSE)

## Author

Jan Antonio Pereira, DevOps Engineer

## <h3 align="center"> © IBM Corporation 2025. All rights reserved. <h3/>

## Excercise 1: Create Fake Products
In the tests/factories.py file, use the Faker providers and Fuzzy attributes to create fake data for the name, description, price, available, and category fields by adding them to the ProductFactory class.

### Solution
```py
class ProductFactory(factory.Factory):
    """Creates fake products for testing"""

    class Meta:
        """Maps factory to data model"""

        model = Product

    id = factory.Sequence(lambda n: n)
    name = FuzzyChoice(
        choices=[
            "Hat",
            "Pants",
            "Shirt",
            "Apple",
            "Banana",
            "Pots",
            "Towels",
            "Ford",
            "Chevy",
            "Hammer",
            "Wrench"
        ]
    )
    description = factory.Faker("text")
    price = FuzzyDecimal(0.5, 2000.0, 2)
    available = FuzzyChoice(choices=[True, False])
    category = FuzzyChoice(
        choices=[
            Category.UNKNOWN,
            Category.CLOTHS,
            Category.FOOD,
            Category.HOUSEWARES,
            Category.AUTOMOTIVE,
            Category.TOOLS,
        ]
    )
```

## Exercise 2: Create Test Cases for the Model
Before we proceed with creating test cases for the Product Model, let us see the different attributes used in this model:
<table>
<thead>
<tr>
<th>Attribute</th>
<th>Description</th>
</tr>
</thead>
<tbody><tr>
<td>id</td>
<td>The id of the product</td>
</tr>
<tr>
<td>name</td>
<td>The name of the product</td>
</tr>
<tr>
<td>description</td>
<td>The description of the product</td>
</tr>
<tr>
<td>price</td>
<td>The price of the product</td>
</tr>
<tr>
<td>available</td>
<td>True if the product is available, otherwise False</td>
</tr>
<tr>
<td>category</td>
<td>The category under which the product belongs</td>
</tr>
</tbody></table>
Please refer to the Reading: About the Product Model (include link to the course reading) to understand the classes and methods used in the models.py file.

The first thing you need to do while creating test cases for the Model, is ensure that the database model is working correctly. Someone wrote all of the code but only wrote a test case for create. You have no idea if the other functions work properly or not.

### Task
Create test cases in tests/test_models.py to exercise the code in service/models.py to test that the Product model works.

1. Write test case to read a product and ensure that it passes
2. Write test case to update a product and ensure that it passes
3. Write test case to delete a product and ensure that it passes
4. Write test case to list all products
5. Write test case to search for a product by name and ensure that it passes
6. Write test case to search for a product by category and ensure that it passes
7. Write test case to search for a product by availability and ensure that it passes


## Exercise 3: Create Test Cases and Code for REST API
Now that you know that the model is working, you can move on to developing the REST API which will accept json requests, call the model, and return an answer as json.

Your REST API must implement the following endpoints:

- Create a Product
- Read a Product
- Update a Product
- Delete a Product
- List all Products
- List Products by Category, Availability, and Name

### Task
Edit the test cases in tests/test_routes.py and code in service/routes.py for a RESTful endpoint using Flask that contains the following endpoints:

1. Write a test case to Read a Product and watch it fail
2. Write the code to make the Read test case pass
3. Write a test case to Update a Product and watch it fail
4. Write the code to make the Update test case pass
5. Write a test case to Delete a Product and watch it fail
6. Write the code to make the Delete test case pass
7. Write a test case to List all Products and watch it fail
8. Write the code to make the List all test case pass
9. Write a test case to List by name a Product and watch it fail
10. Write the code to make the List by name test case pass
11. Write a test case to List by category a Product and watch it fail
12. Write the code to make the List by category test case pass
13. Write a test case to List by availability a Product and watch it fail
14. Write the code to make the List by availability test case pass

## Exercise 4: Load BDD background data
The first thing you will need to do for BDD testing, is write the Python code to load the data from the background: statement in the products.feature file. Remember that the data is stored in the context.table attribute and each row is a Python dictionary (dict) that you can dereference using the names at the top of the columns in the background: statement.

### Task
Update the features/steps/load_steps.py file to load background data from your BDD scenarios into your service before each scenario executes.

The code to delete all of the products is already given to you. You just need to write the code to load the products from context.table.

## Exercise 5: Create BDD Scenarios
Now that the background data is loaded, it’s time to write the scenarios to test the UI. The Create a Product scenario is already written as an example of what you need to do.

The service already contains a UI that looks like this:<br>
<img src="https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBM-CD0241EN-SkillsNetwork/images/final-product-ui.png"/><br>

### Task
- Update the features/products.feature file with BDD Scenarios that prove that the following behaviors of the UI work as expected:
1. Read a Product
2. Update a Product
3. Delete a Product
4. List all Products
5. Search for Products by Category
6. Search for Products by Availability
7. Search for Products by Name

## Exercise 6: Implementing Steps
In BDD, test scenarios are often written in a human-readable format, such as Gherkin, and these scenarios are translated into automated tests using step definitions.

The web_steps.py file contains the step definitions for the web-related actions on the UI.

Please check [Hands-on Lab: Implementing Your First Steps](link to the lab page to be included) for any reference you may need to understand about how step definitions are implemented, before proceeding further.

The step definitions for the first few steps are already given to you.


### Task
Update the features/steps/web_steps.py file with the remaining step definitions.

Start by opening the file web_steps.py.
