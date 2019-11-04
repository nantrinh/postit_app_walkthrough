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
  - We do not add a resource because CRUD actions are not going to be performed on users. Instead, we want to manually build the routes. We follow Rails convention in the naming of the routes.
  - Add `get '/login', to: 'sessions#new'` and `post '/login', to: 'sessions#create'` to `config/routes.rb`.

- Add a SessionsController.
  ```
  # app/controllers/sessions_controller.rb

  class SessionsController < ApplicationController
    def new
    end

    def create
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

# WORK IN PROGRESS 
at -24:58 in solution:authentication video
