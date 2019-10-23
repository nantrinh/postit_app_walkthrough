Create an app called PostIt based on the entity relationship diagram ![ERD](../flashcards/images/ERD_part1.jpg).

Create routes for posts and categories. Prevent the delete route from being accessed.

Create controllers and views to view all posts, all categories, and the post-category relationship. 

Change the association name between posts and user to posts and creator, so we have a better idea of the relationship of the association.

# Create new application
- `rails new postit`
- Run `cd postit`
- Run `rails server`
- Navigate to `http://localhost:3000` in browser and verify that a welcome page is shown.

# Create tables
After creating each migration file and modifying its contents:
1. Run `rails db:migrate`.
2. Run `cat db/schema.rb` to inspect the schema. We want to check if the migration had the intended effects.

## Users
`rails g migration CreateUsers`

```
def change
  create_table :users do |t|
    t.string :username

    t.timestamps
  end
```

## Posts
`rails g migration CreatePosts`

```
def change
  create_table :posts do |t|
    t.string :title
    t.string :url
    t.text :description
    t.belongs_to :user

    t.timestamps
  end
```

## Comments
`rails g migration CreateComments`

```
def change
  create_table :comments do |t|
    t.text :body
    t.belongs_to :user
    t.belongs_to :post

    t.timestamps
  end
```

## Categories
`rails generate migration CreateCategories`

```
def change
  create_table :categories do |t|
    t.string :name

    t.timestamps
  end
```

## PostCategories 
`rails generate migration CreatePostCategories`

```
def change
  create_table :post_categories do |t|
    t.belongs_to :post
    t.belongs_to :category

    t.timestamps
  end
end
```

# Create models
- Run `rails console` to open up the rails console.
- After creating each model file, run `reload!` to reload the console.
- Run `[ModelName].all` to verify that a SQL query is executed to select all rows from the appropriate table. We want to check that each model is hooked up with the appropriate table.

## User
`app/models/user.rb`

```
class User < ActiveRecord::Base
  has_many :comments, dependent: :destroy
end
```

## Post
`app/models/post.rb`

```
class Post < ActiveRecord::Base
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :categories, through: :post_categories, dependent: :destroy
end
```

## Comment
`app/models/comment.rb`

```
class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :post
end
```

## Category
`app/models/category.rb`

```
class Category < ActiveRecord::Base
  has_many :posts , through :post_categories, dependent: :destroy
end
```

## PostCategory
`app/models/post_category.rb`

```
class PostCategory < ActiveRecord::Base
  belongs_to :post
  belongs_to :category
end
```

# Check Associations
TODO: sample code to create rows and check their associations in the db

# Create routes for posts and categories. Prevent the delete route from being accessed.
 
# Create controllers and views to view all posts, all categories, and the post-category relationship. 

# Change the association name between posts and user to posts and creator, so we have a better idea of the relationship of the association.
 
