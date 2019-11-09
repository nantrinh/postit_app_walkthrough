# Instructions
## Add authentication
- Use `has_secure_password` to set up user authentication.
- Add manual routes to log in and log out.
## Add sessions
- Add session capability (a user can be logged in or logged out).
- Add a navigation partial.
  - Always show a link to posts#index and a link to categories#index.
  - If a user is logged in, show a link to create a new post and a link to log out.
  - If a user is not logged in, show a link to register and a link to log in.
- Prevent non-logged-in users from accessing:
  - All `posts` actions except `show` and `index`
  - All `comments` actions
  - `categories` `new` and `create` actions
- Prevent non-logged-in users from viewing:
  - The form to create a new comment
  - Links to edit posts
- Display who created a post and when.
- Edit the posts and comments controller to set the creator to the current user (instead of test user).
## Add CRUD actions for users 
- Allow registration of a new user.
  - Require a username and password.
  - Username must be unique.
  - Password must be at least 5 characters long.

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
  - Prevent non-logged-in users from accessing:
    - All `posts` actions except `show` and `index`: Add `before_action :require_user, except [:show, :index]` to `app/controllers/posts_controller.rb`.
    - All `comments` actions: Add `before_action :require_user` to `app/controllers/comments_controller.rb`.
    - `categories` `new` and `create` actions: Add `before_action :require_user, only: [:new, :create]` to `app/controllers/categories_controller.rb`.
  - Prevent non-logged-in users from viewing:
    - The form to create a new comment: Wrap the form in `<% if logged_in? %>` and `<% end %>`.
    - Links to edit posts: Wrap the links in `<% if logged_in? %>` and `<% end %>`.
  - Display who created a post and when: Add `Created by: <%= @post.creator.username %> at <%= display_datetime(@post.created_at) %>` to `app/views/posts/show.html.erb`.
- Edit the posts and comments controller to set the creator to the current user (instead of test user): `@post.creator = current_user`
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
- Check your changes.
  - Register a new user. Trigger the uniqueness validation first.
  - Verify that you are automatically logged in as the new user upon creation.
  - Create a new post and a new comment as the new user. Check that the creator is displayed correctly. 

# Add Bootstrap Styling
At this point, I give in and finally add styling using [Bootstrap](https://getbootstrap.com/) to my application. I style my app differently than the instructors do.

I didn't fully understand the [official installation instructions](https://github.com/twbs/bootstrap-rubygem), so I consulted [this Medium article](https://medium.com/@biancapower/how-to-add-bootstrap-4-to-a-rails-5-app-650118459a1e) for help.

After styling, my app looks like this: ![](../gifs/postit_lesson_3_demo.gif).

# WORK IN PROGRESS 
- add dropdown for user on nav
- add this under if logged_in? in nav
```

<div>
  <%= link_to("", 'data-toggle' => 'dropdown') do %>
    <%= current_user.username %>
  <% end %>
    <ul>
      <li><%= link_to edit_user_path(current_user) do %>
        edit profile
      <% end %>
      </li>
      <li><%= link_to user_path(current_user) do %>
        view profile
      <% end %>
      </li>
      <li><%= link_to logout_path do %>
        logout
      <% end %>
      </li>
    </ul>
</div>
```
- define actions in controller
```
before_action :set_user, only: [:show, :edit]

def update
  if @user.update(user_params)
    flash[:notice] = "Your profile was updated."
    redirect_to user_path(@user)
  else
    render :edit
  end
end

private

def set_user
  @user = User.find(params[:id])
end
```

- extract form for new user to a partial; use the same form for edit view, except display "Update Profile" in the submit button
    `f.submit(@user.newrecord? ? "Register" : "Update Profile")`
- create user profile page (show)
```
render "Profile: #{@user.username}"
show username: username
show count of user posts

show count of user comments
show the comments that you made, and which post you made it on
since you're using a comment partial, only show this when you're on show_post
<% if show_post %>
  <%= comment.body %> on <%= link_to comment.post.title, post_path(comment.post) %> at <% display_datetime(comment.created_at) %>
<% end %>

past in show_post param if you're on show_post
default it to false in the partial
```

- wherever you have the user's name, as an author of a post or comment, link it to the user page

- only allow a user to edit themselves, not another user
`before_action :require_same_user, only: [:edit, :update]`

```
def require_same_user
  if current_user != @user
    flash[:error] = "You're not allowed to do that."
    redirect_to root_path
  end
end
```
