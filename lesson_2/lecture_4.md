# Lecture 4

## Table of Contents
* [Instructions](#instructions)
* [Change the association name](#change-the-association-name)
* [Allow a user to create a new comment](#allow-a-user-to-create-a-new-comment)
* [Add validations for a new comment](#add-validations-for-a-new-comment)
* [Display all comments related to a post on the posts show view](#display-all-comments-related-to-a-post-on-the-posts-show-view)
* [Allow a user to associate a post with categories](#allow-a-user-to-associate-a-post-with-categories)
* [Allow a user to click on post URLs and navigate to those URLs](#allow-a-user-to-click-on-post-urls-and-navigate-to-those-urls)
* [Display timestamps in a format like "11/01/2019 7:01pm UTC"](#display-timestamps-in-a-format-like-10312019-704pm-utc)
* [Additional Changes](#additional-changes)

## Instructions
- Change the association name between comments and user to comments and creator.
- Allow a user to create a new comment on a post.
  - The form for a new comment should be displayed on the posts `show` view.
  - The form should be submitted via a POST request to `/posts/:post_id/comments`.
- Add the following validations for a new comment. Display validation errors in the posts `show` view.
  - Require `body`.
- Display all comments related to a post on the posts `show` view.
- Allow a user to associate a post with categories when creating a new post and when editing a post.
- Allow a user to click on post URLs and navigate to those URLs.
- Display timestamps in a format like "11/01/2019 7:01pm UTC".
- Add a link to edit the post on the post `show` view.

## Change the association name
```ruby
# app/models/comment.rb

 class Comment < ActiveRecord::Base
   belongs_to :creator, class_name: "User", foreign_key: "user_id"
   belongs_to :post

   validates :body, presence: true
 end
```

## Allow a user to create a new comment 
- Add `create` action. For now, set the default user to "Test". 
  ```ruby
  # app/controllers/comments_controller.rb 
  
  class CommentsController < ApplicationController
    def create
      @post = Post.find(params[:post_id])
  
      @comment = @post.comments.new(comment_params)
  
      @user = User.find_by username: "Test"
      @comment.creator = @user
  
      if @comment.save
        flash[:notice] = "Your comment was added."
        redirect_to post_path(@post)
      else
        render "posts/show"
      end
    end
  
    def comment_params
      params.require(:comment).permit(:body)
    end
  end
  ```
- Add nested route.
  ```ruby
  # config/routes.rb

  Rails.application.routes.draw do
    root to: "posts#index"
  
    resources :categories, except: :destroy
  
    resources :posts, except: :destroy do
      resources :comments, only: :create
    end
  end
  ```
- Create an new instance of a comment in the posts `show` action.
  ```ruby
  # app/controllers/posts_controller.rb
  
  # code omitted for brevity

  def show
    @comment = Comment.new
  end

  # code omitted for brevity
  ```
- Add new comment form to posts `show` view.
  ```ruby
  # app/views/posts/show.html.erb

  # code omitted for brevity

  <%= form_for [@post, @comment] do |f| %>
    <div>
      <%= f.label :body, "Leave a comment" %>
      <br/>
      <%= f.text_area :body, rows: 3 %>
    </div>
    <%= f.submit "Create comment" %>
  <% end %>

  # code omitted for brevity
  ```

## Add validations for a new comment
- Add `validates :body, presence: true` to `app/models/comments.rb`.
- Display validation errors in the posts `show` view.
    ```ruby
    # app/views/posts/show.html.erb

    # specify category id to prevent errors when validations are triggered
    <h1><%= @post.title %></h1>
    
    <%= render 'shared/flash' %>
    
    <p> Tags: 
    <% @post.categories.each do |category| %>
      <%= link_to category.name, category_path(category.id) %>
    <% end %>
    </p>
    
    <p>URL: <%= @post.url %></p>
    <p>Description: <%= @post.description %></p>
    
    # add code to render errors partial
    <%= form_for [@post, @comment] do |f| %>
      <%= render 'shared/errors', obj: @comment %>
      <div>
        <%= f.label :body, "Leave a comment" %>
        <br/>
        <%= f.text_area :body, rows: 3 %>
      </div>
      <%= f.submit "Create comment" %>
    <% end %>
    
    <h5>Comments</h5>
    <% @post.comments.each do |comment| %>
      <article>
        <p><%= comment.body %></p>
        <p><%= comment.creator.username %>, <%= comment.created_at %></p>
      </article>
    <% end %>
    
    <%= link_to "All Posts", posts_path %>
    ```
## Display all comments related to a post on the posts `show` view
```ruby
# app/views/posts/show.html.erb

# code omitted for brevity

<h5>Comments</h5>
<% @post.comments.each do |comment| %>
  <article>
    <p><%= comment.body %></p>
    <p><%= comment.creator.username %>, <%= comment.created_at %></p>
  </article>
<% end %>

<%= link_to "All Posts", posts_path %>
```

## Allow a user to associate a post with categories
- Note: If you want to mass assign an array, you have to use syntax like this in the permit method: `permit(category_ids: [])` .
- Add the code below to the form in `_form.html.erb`.
  ```
  <%= f.label "Categories" %>
  <%= f.collection_check_boxes :category_ids, Category.all, :id, :name do |cb| %>
    <% cb.label {cb.check_box + cb.text.capitalize} %>
  <% end %>
  ```
- Modify the `post_params` method in `app/controllers/posts_controller.rb`.
  ```
  def post_params
    params.require(:post).permit(:title, :url, :description, category_ids: [])
  end
  ```
## Allow a user to click on post URLs and navigate to those URLs
- Ensure that URLs are prepended with `"http://"` when displayed.
  - Add a helper.
  ```
  # app/helpers/application_helper.rb 

  module ApplicationHelper
    def fix_url(str)
      str.starts_with?("http://") ? str : "http://#{str}"
    end
  end
  ```
  - `app/views/posts/index.html.erb` 
    - Replace `post.url` with `fix_url(post.url)`.
  - `app/views/posts/show.html.erb`
    - Replace `@post.url` with `fix_url(@post.url)`.
- Ensure that the `href` attributes are set to the URLs.
- `app/views/posts/index.html.erb` 
  - Replace `link_to fix_url(post.url)` with `link_to(body=fix_url(post.url), url=fix_url(post.url))`.
- `app/views/posts/show.html.erb`
  - Replace `link_to fix_url(@post.url)` with `link_to(body=fix_url(@post.url), url=fix_url(@post.url))`.

## Display timestamps in a format like "11/01/2019 7:01pm UTC" 
- Note: See Ruby docs for [`strftime`](https://ruby-doc.org/stdlib-2.6.1/libdoc/date/rdoc/DateTime.html#method-i-strftime).
- Add a helper.
  ```
  # app/helpers/application_helper.rb 
  
  module ApplicationHelper
  
    # code omitted for clarity 
  
    def display_datetime(dt)
      dt.strftime("%m/%d/%Y %l:%M%P %Z")
    end
  end
  ```
- `app/views/posts/show.html.erb`
  - Replace `comment.created_at` with `display_datetime(comment.created_at)`.

## Additional Changes
- Add a link to edit the post on the post `show` view 
  - Add `<%= link_to "Edit Post", edit_post_path %>` to `app/views/posts/show.html.erb`
