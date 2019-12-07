# Lesson 1
At the end of this lesson, we would have an app deployed on heroku that supports the `posts#index`, `posts#show`, `categories#index`, and `categories#show` actions.

![](../gifs/lesson_1.gif)

The app would have the appropriate models and associations set up according to this entity relationship diagram:

![ERD](https://github.com/nantrinh/ls_rails_notes/blob/master/images/ls/ERD_part1.jpg)

## Table of Contents
* [Course Instructions](#course-instructions)
* [What I Changed](#what-i-changed)
* [What I Added](#what-i-added)
* [Create new application](#create-new-application)
* [Create tables](#create-tables)
   * [Users](#users)
   * [Posts](#posts)
   * [Comments](#comments)
   * [Categories](#categories)
   * [PostCategories](#postcategories)
* [Create a new git repository and make the first commit](#create-a-new-git-repository-and-make-the-first-commit)
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
* [Create controllers](#create-controllers)
* [Install Bootstrap 4](#install-bootstrap-4)
* [Create views](#create-views)
   * [Shared](#shared)
   * [Posts](#posts-1)
   * [Categories](#categories-1)
* [Change the association name](#change-the-association-name)
* [Deploy](#deploy)
* [Additional styling](#additional-styling)
* [Commit and deploy again](#commit-and-deploy-again)

Created by [gh-md-toc](https://github.com/ekalinin/github-markdown-toc)

## Course Instructions
- Create new application.
- Create tables.
- Create routes for posts and categories. Prevent the delete route from being accessed.
- Create controllers and views to view:
  - all posts
  - a specific post and its associated categories
  - all categories
  - a specific category and its associated posts
- Change the association name between posts and user to posts and creator, so we have a better idea of the relationship of the association.

## What I Changed 
- Use PostgreSQL instead of SQLite3 to make deployment easier.
- Deploy early on Heroku instead of waiting until the end of Lesson 3.
- I style the app differently.

## What I Added
- How to install Bootstrap.
- Fixed width and height of post partials.

## Create new application
I use PostgreSQL instead of SQLite3.
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

```ruby
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

```ruby
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

```ruby
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

```ruby
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

```ruby
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

## Create a new git repository and make the first commit
See [docs](https://help.github.com/en/github/getting-started-with-github/create-a-repo) for instructions.
Remember to commit often!

## Create models
### User
```ruby
# app/models/user.rb

class User < ApplicationRecord
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
end
```

### Post
```ruby
# app/models/post.rb
class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :post_categories, dependent: :destroy
  has_many :categories, through: :post_categories
end
```

### Comment
```ruby
# app/models/comment.rb

class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post
end
```

### Category
```ruby
# app/models/category.rb

class Category < ApplicationRecord
  has_many :post_categories, dependent: :destroy
  has_many :posts , through: :post_categories
end
```

### PostCategory
```ruby
# app/models/post_category.rb

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
```ruby
nancy = User.create(username: 'Nancy')
victor = User.create(username: 'Victor')
chili = Post.create(title: 'How to make chili oil', url: 'woksoflife.com', description: 'great recipe on how to make chili oil', user: nancy)
compost = Post.create(title: 'How to make compost', url: 'urbangardening.com', description: 'compost recipe using coffee grounds', user: nancy)
bok_choy = Post.create(title: 'Why bok choy is great for cats', url: 'loveyourcats.com', description: "argument for more greens in your cat's diet", user: victor)

pp User.all # print all users
pp Post.all # print all posts
```

### 1:M association between User and Comment
```ruby
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
```ruby
pp Post.find_by(title: 'How to make chili oil').comments # ['This looks delicious!', "I'm commenting on my own post."]
```

### M:M association between Post and Categories
```ruby
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
- Create routes for posts and categories. Prevent the delete route (destroy action) from being accessed.
- Make the `posts#show` path the root path (home page).
  ```ruby
  # config/routes.db

  Rails.application.routes.draw do
    root to: 'posts#index'
    resources :posts, :categories, except: :destroy
  end
  ```
- Check that the output for `rails routes -g posts` and `rails routes -g categories` do not contain a route for the DELETE method.
 
## Create controllers
```ruby
# app/controllers/posts_controller.rb

class PostsController < ApplicationController
  def index
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
  end
end
```

```ruby
# app/controllers/categories_controller.rb

class CategoriesController < ApplicationController
  def index
    @categories = Category.all
  end

  def show
    @category = Category.find(params[:id])
  end
end
```

## Install Bootstrap 4
I followed the instructions in this [article](https://hackernoon.com/integrate-bootstrap-4-and-font-awesome-5-in-rails-6-u87u32zd).

[NOTE](https://v4-alpha.getbootstrap.com/migration/#components): Bootstrap 4 does not support the Glyphicons icon font used in the videos. I use Font Awesome. The article linked to above includes instructions on how to integrate it in your app.

[NOTE](https://v4-alpha.getbootstrap.com/migration/#components): The `well` class is frequently used in the videos. This class was dropped in Bootstrap v4. I use the [`cards`](https://getbootstrap.com/docs/4.0/components/card/) component in my code, which provides similar functionality.

## Create views
- After the views are created, navigate to the URLs in the browser to verify that the responses are as expected.
  - posts#index: `localhost:3000/posts`
  - posts#show: `localhost:3000/posts/:id`
  - categories#index: `localhost:3000/categories`
  - categories#show: `localhost:3000/categories/:id`
- Make sure your server is running before checking the URLs (run `rails server`).
- I use partials here, which are covered later in the course.
- REMINDER: I style my app differently from the one in the videos.

### Shared
[Note](https://guides.rubyonrails.org/layouts_and_rendering.html#naming-partials): Partials are named with a leading underscore to distinguish them from regular views, even though they are referred to without the underscore.
```
# header partial
# app/views/shared/_header.html.erb

<% post ||= nil %>

<%= render 'shared/nav' %>
<section class='jumbotron text-center'>
  <h1 class='jumbotron-heading'><%= title %></h1>
  <% if post %>
    <p><%= post.url %></p>
    <p><%= "#{post.user.username} #{post.created_at}" %></p>
  <% end %>
</section>
```

```
# navigation bar partial
# app/views/shared/_nav.html.erb

<!--Navbar-->
<nav class='navbar navbar-expand-sm navbar-dark bg-dark'>
  <!-- Navbar brand -->
  <%= link_to 'PostIt', root_path, class: 'navbar-brand' %>
    <!-- Collapse button -->
  <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#basicExampleNav"
    aria-controls="basicExampleNav" aria-expanded="false" aria-label="Toggle navigation">
    <span class="navbar-toggler-icon"></span>
  </button>

  <!-- Collapsible content -->
  <div class="collapse navbar-collapse" id="basicExampleNav">

    <!-- Links -->
    <ul class='navbar-nav'>
      <li class='nav-item'>
        <%= link_to 'Posts', posts_path, class: 'nav-link' %>
      </li>
      <li class='nav-item'>
        <%= link_to 'Categories', categories_path, class: 'nav-link' %>
      </li>
    </ul>
</nav>
```
 
### Posts
```
# post partial
# app/views/posts/_post.html.erb

<article class='card bg-light m-3 post'>
  <header class='card-header'>
    <h5><%= post.title %></h5>
  </header>

  <main class='card-body'>
    <%= post.url %>
    <p class='card-text'>
      <%= post.description %>
    </p>
  </main>

  <footer class='card-footer'>
    <%= "#{post.creator.username} #{post.created_at}" %>
    <nav class='btn-group mt-auto'>
      <%= button_to 'View', post_path(post), method: 'get', class: 'btn btn-sm btn-outline-secondary' %>
      <%= button_to 'Edit', edit_post_path(post), method: 'get', class: 'btn btn-sm btn-outline-secondary border-left-0' %>
    </nav>
  </footer>
</article>
```

```
# app/views/posts/index.html.erb

<%= render 'shared/header', title: 'Posts' %>

<section class="row justify-content-center"> 
  <% @posts.each_with_index do |post, i| %>
    <%= render 'post', post: post %>
  <% end %>
</section>
```

```
# app/views/posts/show.html.erb

<%= render 'shared/header', title: @post.title, post: @post %>

<section class='container justify-content-center'>
  <p><%= simple_format(@post.description) %></p>
</section>
```

### Categories
```
# app/views/categories/index.html.erb

<%= render 'shared/header', title: "Categories" %>

<ul>
<% @categories.each do |category| %>
  <li><%= link_to(category.name.capitalize + " (#{pluralize(category.posts.size, 'post')})", category) %></li>
<% end %>
</ul>
```

```
# app/views/categories/show.html.erb

<% title = "Posts Tagged \"#{@category.name.capitalize}\"" %>
<%= render 'shared/header', title: title %>

<% posts = @category.posts %>
<section class="row justify-content-center"> 
  <% if posts.empty? %>
    No posts to show.
  <% else %>
    <% posts.each_with_index do |post, i| %>
      <%= render 'posts/post', post: post %>
    <% end %>
  <%end %>
</section>
```

## Change the association name
- In `app/models/post.rb`, change the line `belongs_to :user` to `belongs_to :creator, class_name: "User", foreign_key: "user_id"`.
- Open rails console and check that `Post.first.creator` returns the first user object, and `Post.first.user` now throws a `NoMethodError`. 
- In the views, change all instances of `post.user` to `post.creator`.

## Deploy
- I followed the instructions in this [article](https://devcenter.heroku.com/articles/getting-started-with-rails6).
- Add data to your app using the rails console on heroku (`heroku run rails console`) and check that it is displayed as intended. You can use the commands from the [Check Associations](#check-associations) section to add the same data that we added to the development database.

## Additional styling 
- Create a custom scss file. The code below sets a fixed width and height for the post partial, and for its components.
  ```
  # app/javascript/stylesheets/_custom.scss

  .post {
    &.card {
      width: 18rem;
      height: 26rem;
    }
  
    .card-header {
      height: 5rem;
    }
  
    .card-body {
      height: 15rem;
    }
  
    .card-footer {
    height: 6rem;
    }
  } 
  ```
- Add `@import 'custom';` to `app/javascript/stylesheets`.

## Commit and deploy again
- Commit to your repo: `git push origin master`
- Deploy again: `git push heroku master`
- Check your deployed app: `heroku open`
