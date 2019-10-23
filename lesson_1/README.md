# Introduction
This is my attempt to condense what I learned in Lesson 1 of the 5301 Rails Course.
I wrote down the instructions first and went through the entire exercise again from scratch without watching the videos.
I used Rails 6 and Ruby 2.5.3.

# Instructions
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
  has_many :posts, dependent: :destroy
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
  has_many :posts , through: :post_categories, dependent: :destroy
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
Run the following commands in the rails console and check that the output is as expected.
If you encounter errors, try restarting the rails console (not just running `reload!`).
It is assumed that the commands are run sequentially from one section to the next (e.g., commands in "1:M association between User and Post" are run before "1:M association between User and Comment".

## 1:M association between User and Post
```
nancy = User.create(username: "Nancy")
victor = User.create(username: "Victor")
chili = Post.create(title: "How to make chili oil", url: "woksoflife.com", description: "great recipe on how to make chili oil", user: nancy)
compost = Post.create(title: "How to make compost", url: "urbangardening.com", description: "compost recipe using coffee grounds", user: nancy)
bok_choy = Post.create(title: "Why bok choy is great for cats", url: "loveyourcats.com", description: "argument for more greens in your cat's diet", user: victor)

chili.user.username # "Nancy"
bok_choy.find(3).user.username # "Victor"
nancy.posts.map {|x| x.title} # ["How to make chili oil", "How to make compost"]
victor.posts.map {|x| x.title} # ["Why bok choy is great for cats"]
```

## 1:M association between User and Comment
```
Comment.create(body: "I agree!", user: nancy, post: bok_choy)
Comment.create(body: "This looks delicious!", user: victor, post: chili)
Comment.create(body: "I'm commenting on my own post.", user: nancy, post: chili)

nancy.comments.map {|x| x.body} # ["I agree!", "I'm commenting on my own post."]
victor.comments.map {|x| x.body} # ["This looks delicious!"]
```

## 1:M association between Post and Comment
```
chili.comments.map {|x| x.body} # ["This looks delicious!", "I'm commenting on my own post."]
```

## M:M association between Post and Categories
```
recipes = Category.create(name: "recipes")
food = Category.create(name: "food")
cat = Category.create(name: "cat")

PostCategory.create(post: chili, category: recipes)
PostCategory.create(post: chili, category: food)
PostCategory.create(post: bok_choy, category: food)
PostCategory.create(post: bok_choy, category: cat)

recipes.posts.map {|x| x.title} # ["How to make chili oil"]
food.posts.map {|x| x.title} # ["How to make chili oil", "Why bok choy is great for cats"]
cat.posts.map {|x| x.title} # ["Why bok choy is great for cats"]

chili.categories.map {|x| x.name} # ["recipes", "food"]
bok_choy.categories.map {|x| x.name} # ["food", "cat"]
```

# Create routes for posts and categories. Prevent the delete route (destroy action) from being accessed.
`config/routes.db`

```
Rails.application.routes.draw do
  resources :posts, :categories, except: :destroy
end
```

Check that the output for `rails routes -g posts` and `rails routes -g categories` do not contain a route for the DELETE method.
 
# Create controllers and views to view all posts, all categories, and the post-category relationship. 

# Change the association name between posts and user to posts and creator, so we have a better idea of the relationship of the association.
 
