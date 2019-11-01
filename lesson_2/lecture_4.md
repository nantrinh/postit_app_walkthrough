# Lecture 4

## Table of Contents
* [Instructions](#instructions)
* [Change the association name](#change-the-association-name)
* [Allow a user to create a new comment](#allow-a-user-to-create-a-new-comment)
* [Add validations for a new comment](#add-validations-for-a-new-comment)
* [Display all comments related to a post on the posts show view](#display-all-comments-related-to-a-post-on-the-posts-show-view)
   * [Select categories on new/edit post form](#select-categories-on-newedit-post-form)
   * [Show Category page](#show-category-page)
   * [Helpers](#helpers)

## Instructions
- Change the association name between comments and user to comments and creator.
- Allow a user to create a new comment on a post.
  - The form for a new comment should be displayed on the posts `show` view.
  - The form should be submitted via a POST request to `/posts/:post_id/comments`.
- Add the following validations for a new comment. Display validation errors in the posts `show` view.
  - Require `body`.
- Display all comments related to a post on the posts `show` view.

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

### Select categories on new/edit post form
On the post form, expose either a combo box or check boxes to allow selection of categories for this post. Hint: use the category_ids virtual attribute.

### Show Category page 
After your posts are associated with categories, display the categories that each post is associated with. When clicking on the category, take the user to the show category page where all the posts associated with that category are displayed. Look at the sample app for workflow ideas, but feel free to be creative!

### Helpers
Use Rails helpers to fix the url format as well as output a more friendly date-time format.
