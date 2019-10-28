# Lecture 3 
This document follows along with Lesson 2, Lecture 3 of the Launch School 5301 Rails Course. There are some differences in the implementations but the main ideas are the same. I used Rails 6 and Ruby 2.5.3. I did not use Twitter Bootstrap.

## Instructions
- Allow a user to create a new post. Use a model-backed form.
- Add the following validations for a new post. Display validation errors in the `new` view.
  - Require `title`, `url`, and `description`.
  - `title` must be at least 5 characters.
  - `url` must be unique.
- Allow a user to update a post. Use a model-backed form.
- Use `before_action` to set up an instance variable needed for the `show`, `edit`, and `update` methods of the posts controller.
- Extract common code used in the `new` and `edit` views to partials.
- Allow a user to create a new category. Use a model-backed form.
- Add the following validations for a new post. Display validation errors in the `new` view.
  - Require `name`.
  - `name` must be unique.
- Extract the part of the category and post forms that displays validation errors to a partial.

## Allow a user to create a new post
- Create a test user.
  - Run `User.create(username: "Test")` in rails console.
- Add `new` and `create` actions. For now, set the default user to "Test".
  ```
  # app/controllers/posts_controller.rb
  
  class PostsController < ApplicationController
    # code omitted for brevity 
  
    def new
      @post = Post.new
    end
  
    def create
      @post = Post.new(post_params)
  
      # TODO: change to logged in user
      @post.creator = User.find_by username: "Test" 
  
      if @post.save
        flash[:notice] = "Your post was created."
        redirect_to posts_path
      else
        render :new
      end
    end
  
    private
  
    def post_params
      params.require(:post).permit!
    end
  end
  ```
- Add `new` view.
  - [Note](https://guides.rubyonrails.org/form_helpers.html#using-form-for-and-form-tag): `form_with` was introduced in Rails 5.1. `form_for` is now [soft-deprecated](https://guides.rubyonrails.org/upgrading_ruby_on_rails.html#upgrading-from-rails-5-0-to-rails-5-1), which means that you can still use `form_for` for now; your code will not break and no deprecation warning will be displayed, but `form_for` will be removed in the future.
  ```
  # app/views/posts/new.html.erb
  
  <h4>Create a new post</h4>
  
  <%= form_with model: @post do |f| %>
    <div>
      <%= f.label :title %>
      <%= f.text_field :title %>
    </div>
    <div>
      <%= f.label :url %>
      <%= f.text_field :url %>
    </div>
    <div>
      <%= f.label :description %>
      <%= f.text_area :description, rows: 5 %>
    </div>
    <%= f.submit "Create Post" %>
  <% end %>
  ```
- Edit `index` view.
  - Add link to create a new post.
  - Add flash notice display using partial.
  ```
  # app/views/posts/index.html.erb

  <%= render 'shared/flash' %>
  <%= link_to "New Post", new_post_path %>
  
  # code omitted for brevity
  ```
  ```
  # app/views/shared/_flash.html.erb

  <% if flash[:notice] %>
    <div><%= flash[:notice] %></div>
  <% end %>
  ```
- Test your changes.
  - Create a new post.
  - Check `index` view ("/posts") to see if the post was created and flash notice is displayed.

## Add validations for a new post
- Add validations to model.
  ```
  # app/models/post.rb
  
  class Post < ActiveRecord::Base
    belongs_to :creator, class_name: "User", foreign_key: "user_id"
    has_many :comments, dependent: :destroy
    has_many :post_categories, dependent: :destroy
    has_many :categories, through: :post_categories
  
    validates :title, presence: true, length: {minimum: 5}
    validates :url, presence: true, uniqueness: true
    validates :description, presence: true
  end
  ```
- Display validation errors in `new` view.
  - [Note](https://guides.rubyonrails.org/v6.0/working_with_javascript_in_rails.html#form-with): `form_with` submits forms using Ajax by default. To follow along with the exercise in class, disable this behavior by setting the `local` option to `true`.
  ```
  # app/views/posts/new.html.erb
  
  <h4>Create a new post</h4>
  
  <% if @post.errors.any? %>
    <h5>Please fix the following errors:</h5>
    <ul>
      <% @post.errors.full_messages.each do |msg| %>
        <li><%= msg %></li>
      <% end %>
    </ul>
  <% end %>
  
  <%= form_with(model: @post, local: true) do |f| %>
    <div>
      <%= f.label :title %>
      <%= f.text_field :title %>
    </div>
    <div>
      <%= f.label :url %>
      <%= f.text_field :url %>
    </div>
    <div>
      <%= f.label :description %>
      <%= f.text_area :description, rows: 5 %>
    </div>
    <%= f.submit "Create Post" %>
  <% end %>

  <%= link_to "All Posts", posts_path %>
  ```
- Test your changes.
  - Try to submit a new post with inputs that trigger all of the validation errors, then change the inputs incrementally to pass each of the validations in turn.
  - Check that the error messages show up in the view as intended.
  - Check that the post is created successfully if all validations are satisfied.

## Allow a user to edit a post
- Add `edit` and `update` actions.
  ```
  # app/controllers/posts_controller.rb
  
  class PostsController < ApplicationController
  
    # code omitted for brevity 
  
    def edit
      @post = Post.find(params[:id])
    end
  
    def update
      @post = Post.find(params[:id])
  
      if @post.update(post_params)
        flash[:notice] = "This post was updated."
        redirect_to post_path(@post)
      else
        render :edit
      end
    end
  
    private
  
    def post_params
      params.require(:post).permit!
    end
  end
  ```
- Add `edit` view.
  ```
  # app/views/posts/edit.html.erb 
  
  <h4>Edit this post</h4>
  
  <% if @post.errors.any? %>
    <h5>Please fix the following errors:</h5>
    <ul>
      <% @post.errors.full_messages.each do |msg| %>
        <li><%= msg %></li>
      <% end %>
    </ul>
  <% end %>
  
  <%= form_with(model: @post, local: true) do |f| %>
    <div>
      <%= f.label :title %>
      <%= f.text_field :title %>
    </div>
    <div>
      <%= f.label :url %>
      <%= f.text_field :url %>
    </div>
    <div>
      <%= f.label :description %>
      <%= f.text_area :description, rows: 5 %>
    </div>
    <%= f.submit "Update Post" %>
  <% end %>

  <%= link_to "All Posts", posts_path %>
  ```
- Add links to edit each post. 
  ```
  # app/views/posts/index.html.erb

  <h1>Posts</h1>
  
  <%= link_to "New Post", new_post_path %>
  
  <% if flash[:notice] %>
    <div><%= flash[:notice] %></div>
  <% end %>
   
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
          <td><%= link_to "Edit", edit_post_path(post) %></td>
        </tr>
      <% end %>
    </tbody>
  </table>
  ```
- Test your changes.
  - Try to update a post with inputs that trigger all of the validation errors, then change the inputs incrementally to pass each of the validations in turn.
  - Check that the error messages show up in the view as intended.
  - Check that the post is updated successfully if all validations are satisfied.

## Simplify posts controller using `before_action`
  ```
  # app/controllers/posts_controller.rb
  
  class PostsController < ApplicationController
    before_action :set_post, only: [:show, :edit, :update]
  
    # code omitted for brevity
  
    def show
    end
  
    # code omitted for brevity
  
    def edit
    end
  
    def update
      if @post.update(post_params)
        flash[:notice] = "This post was updated."
        redirect_to post_path(@post)
      else
        render :edit
      end
    end
  
    private
  
    # code omitted for brevity
  
    def set_post
      @post = Post.find(params[:id])
    end
  end
  ```

## Extract common code in the `new` and `edit` views to a partial
- [Note](https://api.rubyonrails.org/v6.0.0/classes/ActionView/Helpers/FormBuilder.html#method-i-submit): In Rails 6, when no value is given for the `submit` method, if the ActiveRecord object is a new record, it will use "Create Post" as the submit button label; otherwise it uses "Update Post". The Launch School videos show an older version of Rails, so they coded this behavior explicitly.
- [Note](https://guides.rubyonrails.org/layouts_and_rendering.html#naming-partials): Partials are named with a leading underscore to distinguish them from regular views, even though they are referred to without the underscore.
  ```
  # app/views/posts/_form.html.erb
  
  <% if @post.errors.any? %>
    <h5>Please fix the following errors:</h5>
    <ul>
      <% @post.errors.full_messages.each do |msg| %>
        <li><%= msg %></li>
      <% end %>
    </ul>
  <% end %>
  
  <%= form_with(model: @post, local: true) do |f| %>
    <div>
      <%= f.label :title %>
      <%= f.text_field :title %>
    </div>
    <div>
      <%= f.label :url %>
      <%= f.text_field :url %>
    </div>
    <div>
      <%= f.label :description %>
      <%= f.text_area :description, rows: 5 %>
    </div>
    <%= f.submit %>
  <% end %>
  ```

  ```
  # app/views/posts/new.html.erb
  
  <h4>Create a new post</h4>
  
  <%= render 'form' %>

  <%= link_to "All Posts", posts_path %>
  ```

  ```
  # app/views/posts/edit.html.erb
  
  <h4>Edit this post</h4>
  
  <%= render 'form' %>

  <%= link_to "All Posts", posts_path %>
  ```
- Test your changes.
  - Verify that the behavior of the `new` and `edit` views are unaffected.

## Allow a user to create a new category
- Add `new` and `create` actions. Downcase the name before saving.
  ```
  # app/controllers/categories_controller.rb

  class CategoriesController < ApplicationController
    # code omitted for brevity
  
    def new
      @category = Category.new
    end
  
    def create
      @category = Category.new(category_params)  
      @category.name = @category.name.downcase
  
      if @category.save
        flash[:notice] = "A new category was created."
        redirect_to categories_path
      else
        render :new 
      end
    end
  
    # code omitted for brevity
  
    private
  
    def category_params
      params.require(:category).permit!
    end
  end
  ```
- Add validation for a new category.
  ```
  # app/models/category.rb 

  class Category < ApplicationRecord
    has_many :post_categories, dependent: :destroy
    has_many :posts , through: :post_categories
  
    validates :name, presence: true, uniqueness: true
  end
  ```
- Add `new` view. Use a partial.
  ```
  # app/views/categories/new.html.erb

  <h4>Create a new post</h4>
  
  <%= render 'form' %>
  ```

  ```
  # app/views/categories/_form.html.erb

  <% if @category.errors.any? %>
    <h5>Please fix the following errors:</h5>
    <ul>
      <% @category.errors.full_messages.each do |msg| %>
        <li><%= msg %></li>
      <% end %>
    </ul>
  <% end %>

  <%= form_with(model: @category, local: true) do |f| %>
    <div>
      <%= f.label :name %>
      <%= f.text_field :name %>
    </div>
    <%= f.submit %>
  <% end %>
  ```
- Edit `index` view.
  - Add link to create a new category.
  - Add flash notice display using partial.
  ```
  # app/views/categories/index.html.erb
  
  <%= render 'shared/flash' %>
  <%= link_to "New Category", new_category_path %>

  # code omitted for brevity
  ```
- Test your changes.
  - Create a new category.
  - Check `index` view ("/categories") to see if the category was created.

## Extract validation error code to a partial
```
# app/views/posts/_form.html.erb

<%= render 'shared/errors', obj: @post %>

<%= form_with(model: @post, local: true) do |f| %>
  <div>
    <%= f.label :title %>
    <%= f.text_field :title %>
  </div>
  <div>
    <%= f.label :url %>
    <%= f.text_field :url %>
  </div>
  <div>
    <%= f.label :description %>
    <%= f.text_area :description, rows: 5 %>
  </div>
  <%= f.submit %>
<% end %>
```
```
# app/views/categories/_form.html.erb

<%= render 'shared/errors', obj: @category %>

<%= form_with(model: @category, local: true) do |f| %>
  <div>
    <%= f.label :name %>
    <%= f.text_field :name %>
  </div>
  <%= f.submit %>
<% end %>
```
```
# app/views/shared/_errors.html.erb

<% if obj.errors.any? %>
  <h5>Please fix the following errors:</h5>
  <ul>
    <% obj.errors.full_messages.each do |msg| %>
      <li><%= msg %></li>
    <% end %>
  </ul>
<% end %>
```