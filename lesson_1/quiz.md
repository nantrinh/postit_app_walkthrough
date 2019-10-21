Why do they call it a relational database?

What is SQL?

There are two predominant views into a relational database. What are they, and how are they different?

In a table, what do we call the column that serves as the main identifier for a row of data? We're looking for the general database term, not the column name.

What is a foreign key, and how is it used?

At a high level, describe the ActiveRecord pattern. This has nothing to do with Rails, but the actual pattern that ActiveRecord uses to perform its ORM duties.

If there's an ActiveRecord model called "CrazyMonkey", what should the table name be?

If I'm building a 1:M association between Project and Issue, what will the model associations and foreign key be?

Given this code

class Zoo < ActiveRecord::Base
 	  has_many :animals
end
What do you expect the other model to be and what does database schema look like?
What are the methods that are now available to a zoo to call related to animals?
How do I create an animal called "jumpster" in a zoo called "San Diego Zoo"?
What is mass assignment? What's the non-mass assignment way of setting values?

Suppose Animal is an ActiveRecord model. What does this code do? Animal.first

If I have a table called "animals" with a column called "name", and a model called Animal, how do I instantiate an animal object with name set to "Joe". Which methods makes sure it saves to the database?

How does a M:M association work at the database level?

What are the two ways to support a M:M association at the ActiveRecord model level? Pros and cons of each approach?

Suppose we have a User model and a Group model, and we have a M:M association all set up. How do we associate the two?
