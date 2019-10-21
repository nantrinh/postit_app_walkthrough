Create an app called PostIt based on the entity relationship diagram ![ERD](../flashcards/images/ERD_part1.jpg).

Create routes for posts and categories. Prevent the delete route from being accessed.

Create controllers and views to view all posts, all categories, and the post-category relationship. 

Change the association name between posts and user to posts and creator, so we have a better idea of the relationship of the association.

# Create new application
- `rails new postit`
- check: `cd postit`, `rails server`, `http://localhost:3000` in browser

# Create users table
- `rails generate migration CreateUsers`
- In the generated file, put:
  ```
  def change
    create_table :users do |t|
      t.string :username
 
      t.timestamps
    end
  ```
- `rails db:migrate`
- check: `cat db/schema.rb`

# Create comments table
- `rails generate migration CreateComments`
- In the generated file, put:
  ```
  def change
    create_table :comments do |t|
      t.text :body
 
      t.timestamps
    end
  ```
- `rails db:migrate`
- check: `cat db/schema.rb`

# Create posts table
- `rails generate migration CreatePosts`
- In the generated file, put:
  ```
  def change
    create_table :comments do |t|
      t.string :title
      t.string :url
      t.text :description
 
      t.timestamps
    end
  ```
- `rails db:migrate`
- check: `cat db/schema.rb`

# Create categories table
- `rails generate migration CreateCategories`
- In the generated file, put:
  ```
  def change
    create_table :categories do |t|
      t.string :name
 
      t.timestamps
    end
  ```
- `rails db:migrate`
- check: `cat db/schema.rb`

# Create post_categories join table
- `rails generate migration CreateJoinTablePostCategory post category`
- The generated file should have the following contents:
  ```
  def change
    create_join_table :posts, :categories do |t|
      # t.index [:post_id, :category_id]
      # t.index [:category_id, :post_id]
    end
  end
  ```
- `rails db:migrate`
- check: `cat db/schema.rb`

# Add user reference to post 
- `rails generate migration AddUserRefToPost user:references`
- In the generated file, put:
  ```
  def change
    create_table :post_categories do |t|
       
      t.timestamps
    end
  ```
- `rails db:migrate`
- check: `cat db/schema.rb`

# Add user and post reference to comment 


## Create User ActiveRecord Model
- create a new file `app/models/user.rb` with contents `class User < ApplicationRecord; end`
- check in rails console: `User` should return 

