# Lesson 1
In this lesson, I set up a new application based on the following entity relationship diagram:

![ERD](https://github.com/nantrinh/ls_rails_notes/blob/master/images/ls/ERD_part1.jpg)

## Instructions
- Create new application.
- Create tables.
- Create routes for posts and categories. Prevent the delete route from being accessed.
- Create controllers and views to view:
  - all posts
  - a specific post and its associated categories
  - all categories
  - a specific category and its associated posts
- Change the association name between posts and user to posts and creator, so we have a better idea of the relationship of the association.

## My Additions/Changes/Clarifications
- Use postgresql instead of sqlite3 to make deployment easier.
- Deploy early on Heroku instead of waiting until the end of Lesson 3. I do this because when I went through the course initially and reached the deployment stage, I couldn't get it to work. I wish I deployed early to save myself the headache of trying to figure it out later. So I add this here.
- Add instructions on how to install Bootstrap. The course does not mention how to do this so I figured it out myself and added it here for reference.

## Table of Contents

   * [Create new application](#create-new-application)
   * [Create tables](#create-tables)
      * [Users](#users)
      * [Posts](#posts)
      * [Comments](#comments)
      * [Categories](#categories)
      * [PostCategories](#postcategories)
   * [Create models](#create-models)
      * [User](#user)
      * [Post](#post)
      * [Comment](#comment)
      * [Category](#category)
      * [PostCategory](#postcategory)
   * [Check associations](#check-associations)
      * [1:M association between User and Post](#1m-association-between-user-and-post)
      * [1:M association between User and Comment](#1m-association-between-user-and-comment)
      * [1:M association between Post and Comment](#1m-association-between-post-and-comment)
      * [M:M association between Post and Categories](#mm-association-between-post-and-categories)
   * [Create routes](#create-routes)
   * [Create controllers and views](#create-controllers-and-views)
      * [Create controllers](#create-controllers)
      * [Create views](#create-views)
         * [posts#index](#postsindex)
         * [posts#show](#postsshow)
         * [categories#index](#categoriesindex)
         * [categories#show](#categoriesshow)
   * [Change the association name.](#change-the-association-name)

## Create new application
I use PostgreSQL instead of sqlite3 to make deployment easier.
Helpful articles: [1](https://launchschool.com/blog/how-to-install-postgres-for-linux), [2](https://www.digitalocean.com/community/tutorials/how-to-set-up-ruby-on-rails-with-postgres)

Make sure you are not in an existing git repo. It would be easier to deploy if the app is in its own repo and not nested within another one.
- `rails new postit --database=postgresql`
- `cd postit`
- `rake db:setup`
- `rails db:migrate`
- `rails server`
- Navigate to `http://localhost:3000` in browser and verify that a welcome page is shown. 

## Create tables
After creating each migration file and modifying its contents:
1. Run `rails db:migrate`.
2. Check your changes: Run `cat db/schema.rb` to inspect the schema and verify that the migration had the intended effects.

### Users
`rails g migration create_users`

```
class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :username
  
      t.timestamps
    end
  end
end
```

### Posts
`rails g migration create_posts`

```
class CreatePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :posts do |t|
      t.string :title
      t.string :url
      t.text :description
      t.belongs_to :user
  
      t.timestamps
    end
  end
end
```

### Comments
`rails g migration create_comments`

```
class CreateComments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|
      t.text :body
      t.belongs_to :user
      t.belongs_to :post
  
      t.timestamps
    end
  end
end
```

### Categories
`rails generate migration create_categories`

```
class CreateCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :categories do |t|
      t.string :name
  
      t.timestamps
    end
  end
end
```

### PostCategories 
`rails generate migration create_post_categories`

```
class CreatePostCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :post_categories do |t|
      t.belongs_to :post
      t.belongs_to :category
  
      t.timestamps
    end
  end
end
```

## Create a new git repository and make the first commit.
See [docs](https://help.github.com/en/github/getting-started-with-github/create-a-repo) for instructions.
Remember to commit often!

## Create models
### User
`app/models/user.rb`

```
class User < ApplicationRecord
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
end
```

### Post
`app/models/post.rb`

```
class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :post_categories, dependent: :destroy
  has_many :categories, through: :post_categories
end
```

### Comment
`app/models/comment.rb`

```
class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post
end
```

### Category
`app/models/category.rb`

```
class Category < ApplicationRecord
  has_many :post_categories, dependent: :destroy
  has_many :posts , through: :post_categories
end
```

### PostCategory
`app/models/post_category.rb`

```
class PostCategory < ApplicationRecord
  belongs_to :post
  belongs_to :category
end
```

## Check associations
- Run the following commands in the rails console and check that the output is as expected.
- If you encounter errors, try restarting the rails console (not just running `reload!`).
- It is assumed that the commands are run sequentially from one section to the next (e.g., commands in "1:M association between User and Post" are run before "1:M association between User and Comment".
- I include repetitive code so even if you encounter an error and have to restart the console you won't have to look through all the snippets to find out what a variable referred to (e.g., `chili = Post.find_by(title: 'How to make chili oil')`)

### 1:M association between User and Post
```
nancy = User.create(username: 'Nancy')
victor = User.create(username: 'Victor')
chili = Post.create(title: 'How to make chili oil', url: 'woksoflife.com', description: 'great recipe on how to make chili oil', user: nancy)
compost = Post.create(title: 'How to make compost', url: 'urbangardening.com', description: 'compost recipe using coffee grounds', user: nancy)
bok_choy = Post.create(title: 'Why bok choy is great for cats', url: 'loveyourcats.com', description: 'argument for more greens in your cat's diet', user: victor)

pp User.all # print all users
pp Post.all # print all posts
```

### 1:M association between User and Comment
```
nancy = User.find_by(username: 'Nancy')
victor = User.find_by(username: 'Victor')
chili = Post.find_by(title: 'How to make chili oil')
bok_choy = Post.find_by(title: 'Why bok choy is great for cats')

Comment.create(body: 'I agree!', user: nancy, post: bok_choy)
Comment.create(body: 'This looks delicious!', user: victor, post: chili)
Comment.create(body: "I'm commenting on my own post.", user: nancy, post: chili)

pp nancy.comments
pp victor.comments
```

### 1:M association between Post and Comment
```
pp Post.find_by(title: 'How to make chili oil').comments # ['This looks delicious!', "I'm commenting on my own post."]
```

### M:M association between Post and Categories
```
recipes = Category.create(name: "recipes")
food = Category.create(name: "food")
cat = Category.create(name: "cat")

chili = Post.find_by(title: 'How to make chili oil')
bok_choy = Post.find_by(title: 'Why bok choy is great for cats')

PostCategory.create(post: chili, category: recipes)
PostCategory.create(post: chili, category: food)
PostCategory.create(post: bok_choy, category: food)
PostCategory.create(post: bok_choy, category: cat)

pp recipes.posts # ["How to make chili oil"]
pp food.posts # ["How to make chili oil", "Why bok choy is great for cats"]
pp cat.posts # ["Why bok choy is great for cats"]

pp chili.categories # ["recipes", "food"]
pp bok_choy.categories # ["food", "cat"]
```

## Create routes
Create routes for posts and categories. Prevent the delete route (destroy action) from being accessed.
`config/routes.db`

```
Rails.application.routes.draw do
  resources :posts, :categories, except: :destroy
end
```

Check that the output for `rails routes -g posts` and `rails routes -g categories` do not contain a route for the DELETE method.
 
## Create controllers and views
Create controllers and views to view:
- all posts
- a specific post and its associated categories
- all categories
- a specific category and its associated posts

### Create controllers
`app/controllers/posts.rb`

```
class PostsController < ApplicationController
  def index
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
  end
end
```

`app/controllers/categories.rb`

```
class CategoriesController < ApplicationController
  def index
    @categories = Category.all
  end

  def show
    @category = Category.find(params[:id])
  end
end
```

### Create views
After each view is created, navigate to the appropriate URL in the browser to verify that the response is as expected.
Make sure your server is running before checking the URLs (run `rails server`).
#### posts#index
`app/views/posts/index.html.erb`
`localhost:3000/posts`

```
<h1>Posts</h1>
 
<table>
  <thead>
    <tr>
      <th>Title</th>
      <th>URL</th>
      <th>Description</th>
    </tr>
  </thead>
 
  <tbody>
    <% @posts.each do |post| %>
      <tr>
        <td><%= post.title %></td>
        <td><%= post.url %></td>
        <td><%= post.description %></td>
        <td><%= link_to "Show", post %></td>
      </tr>
    <% end %>
  </tbody>
</table>
```

#### posts#show
`app/views/posts/show.html.erb`
`localhost:3000/posts/:id`

```
<h1><%= @post.title %></h1>

<p> Tags: 
<% @post.categories.each do |category| %>
  <%= link_to category.name, category_path %>
<% end %>
</p>

<p>URL: <%= @post.url %></p>
<p>Description: <%= @post.description %></p>
<%= link_to "All Posts", posts_path %>
```

#### categories#index
`app/views/categories/index.html.erb`
`localhost:3000/categories`

```
<h1>Categories</h1>

<ul>
<% @categories.each do |category| %>
  <li><%= link_to category.name.capitalize, category %></li>
<% end %>
</ul>
```

#### categories#show
`app/views/categories/show.html.erb`
`localhost:3000/categories/:id`

```
<h1>Posts Tagged "<%= @category.name.capitalize %>"</h1>

<table>
  <thead>
    <tr>
      <th>Title</th>
      <th>URL</th>
      <th>Description</th>
    </tr>
  </thead>
 
  <tbody>
    <% @category.posts.each do |post| %>
      <tr>
        <td><%= post.title %></td>
        <td><%= post.url %></td>
        <td><%= post.description %></td>
        <td><%= link_to "Show", post %></td>
      </tr>
    <% end %>
  </tbody>
</table>

<%= link_to "All Categories", categories_path %>
```

## Change the association name.

- In `app/models/post.rb`, change the line `belongs_to :user` to `belongs_to :creator, class_name: "User", foreign_key: "user_id"`.
- Open rails console and check that `Post.first.creator` returns the first user object, and `Post.first.user` now throws a `NoMethodError`. 
