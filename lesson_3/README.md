# Add authentication
- Create a new column to store the password digest. It must be called `password_digest` to conform to Rails convention.
  - `rails g migration add_password_digest_to_users`

  ```
  def change
    add_column :users, :password_digest, :string
  end
  ```
  - `rails db:migrate`
- Add `has_secure_password validations: false` to `app/models/user.rb`
- Add `gem bcrypt` to `Gemfile`. Run `bundle install`.
- Test your changes in `rails console`.
  ```
  user = User.find(1)
  user.password = 'password'
  user.save

  # exit out of rails console and start it again
  user = User.find(1)
  user.password # nil
  user.password_digest # a long string of gibberish
  user.authenticate('hello') # false
  user.authenticate('password') # the user object 
  ```
- Add routes.
  - We follow Rails convention in the naming of the routes.
  - Add the following routes to `config/routes.rb`.
    ```
    get '/login', to: 'sessions#new'
    post '/login', to: 'sessions#create'
    get '/logout', to: 'sessions#destroy'
    ```

- Add a SessionsController.
  ```
  # app/controllers/sessions_controller.rb

  class SessionsController < ApplicationController
    def new
    end

    def create
    end

    def destroy
    end
  end
  ```
- Add a view.
  - We are not using model-backed form helpers because sessions is not a resource.
  ```
  # app/views/sessions/new.html.erb

  <h5>Log In</h5>
  <div>
    <%= form_tag '/login' do %>
      <div>
        <%= label_tag :username %>
        <%= text_field_tag :username %>
      </div>
      <div>
        <%= label_tag :password %>
        <%= password_field_tag :password %>
      </div>
      <%= submit_tag 'Login' %>
    <% end %>
  </div>
  ```
  - Navigate to `localhost:3000/login` and verify that the form is displayed.

# Add sessions
- Edit sessions controller.
  ```
  # app/controllers/sessions_controller.rb 

  class SessionsController < ApplicationController
    def new
    end

    def create
      user = User.find_by(username: params[:username])
      if user && user.authenticate(params[:password])
        session[:user_id] = user.id
        flash[:notice] = "Welcome, you've logged in."
        redirect_to root_path
      else
        flash.now[:error] = "There is something wrong with your username or password."
        render :new
      end
    end
    
    def destroy
      session[:user_id] = nil
      redirect_to root_path
    end
  end
  ```
- Edit application controller.
  - Note: `||=` is used to prevent multiple database queries from being made in one request. The rest of the statement is not executed if `@current_user` is truthy. This technique is known as memoization. 
  - Note: `helper_method` makes the methods available in all of the controllers and view templates.
  ```
  # app/controllers/application_controller.rb

  class ApplicationController < ActionController::Base
    helper_method :current_user, :logged_in?
    
    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end
    
    def logged_in?
      !!current_user
    end
  end
  ```
- Edit views.
  - Add navigation partial.
    ```
    # app/views/shared/_nav.html.erb

    <nav>
      <ul>
        <li><%= link_to "Posts", posts_path %>
        <li><%= link_to "Categories", categories_path %>
    
        <% if logged_in? %>
          <li><%= link_to "New Post", new_post_path %>
          <li><%= link_to "Log Out", logout_path %>
        <% else %>
          <li><%= link_to "Log In", login_path %>
        <% end %>
      </ul>
    </nav>
    ```
  - Add header partial.
    ```
    # app/views/shared/_header.html.erb

    <%= render 'shared/nav' %>
    <h1><%= title %></h1>
    ```
  - Edit all views to use the header partial. For example, add `<%= render 'shared/header', title: "Log In" %>` to `app/views/sessions/new.html.erb`.
- Restrict certain actions to logged-in users.
  - Add a `require_user` method to `app/controllers/application_controller.rb`.
    ```
    def require_user
      if !logged_in?
        flash[:error] = "Must be logged in to do that."
        redirect_to root_path
      end
    end
    ```
  - Require a user to be logged in for all `posts` actions except `show` and `index`.
    - Add `before_action :require_user, except [:show, :index]` to `app/controllers/posts_controller.rb`.
  - Require a user to be logged in for all `comments` actions.
    - Add `before_action :require_user` to `app/controllers/comments_controller.rb`.
  - Require a user to be logged in for the `new` and `create` `categories` actions.
    - Add `before_action :require_user, only: [:new, :create]` to `app/controllers/categories_controller.rb`.
  - Hide the form to create a new comment and the links to edit posts from the user unless they are logged in.
    - Wrap the pertinent lines of code in the views in `<% if logged_in? %>` and `<% end %>`.
  - Display who created a post and when.
    - Add `Created by: <%= @post.creator.username %> at <%= display_datetime(@post.created_at) %>` to `app/views/posts/show.html.erb`.
- Edit the posts and comments controller to set the creator to the current user (instead of test user).
  - `@post.creator = current_user`
- Check your changes.
  - Verify that you can log in and log out.
  - Verify that certain parts of the UI only show up if the user is logged in.
  - Verify that users cannot access certain routes (e.g., `localhost:3000/posts/new`) unless they are logged in.
  - Verify that the logged_in user's name is displayed when a new post is created.
  - Verify that the logged_in user's name is displayed when a new comment is created.

# Add CRUD actions for users
- Edit `config/routes.rb`.
  - Add `resources :users, only: [:show, :create, :edit, :update]`.
  - Add `get '/register', to: 'users#new'`.
- Add validations to `app/models/post.rb` 
  ```
  validates :username, presence: true, uniqueness: true
  validates :password, presence: true, on: create, length: {minimum: 5}
  ```
- Add actions to users controller.
  ```
  class UsersController < ApplicationController
    def new
      @user = User.new
    end
    
    def create
      @user = User.new(user_params)
    
      if @user.save
        session[:user_id] = @user.id
        flash[:notice] = "You are registered."
        redirect_to root_path
      else
        render :new
      end
    end
    
    private
    
    def user_params
      params.require(:user).permit(:username, :password)  
    end
  end
  ```
- Add `new` view.
  ```
  # app/views/users/new.html.erb
  
  <%= render 'shared/header', title: "Register" %>
  
  <%= form_with(model: @user, local: true) do |f| %>
    <%= render 'shared/errors', obj: @user %>
    <div>
      <%= f.label :username %>
      <%= f.text_field :username %>
    </div>
    <div>
      <%= f.label :password %>
      <%= f.password_field :password %>
    </div>
    <%= f.submit "Register" %>
  <% end %>
  ```
- If user is not logged in, display link to register.
  - Add `<%= link_to 'Register', register_path %>` to `app/views/shared/_nav.html.erb`.

# WORK IN PROGRESS 
