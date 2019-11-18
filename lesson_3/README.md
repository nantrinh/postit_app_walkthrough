# Lesson 3

## Table of Contents
[TODO]

## Course Instructions
### Lecture 5
- Use `has_secure_password` to set up user authentication.
#### Sessions
- Allow a user to log in and log out. Use these custom routes:
  ```
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
  ```
- Add view to log in.
- Edit navigation bar.
  - Always show links to all posts and all categories.
  - If a user is not logged in, show links to:
    - Register
    - Log in
  - If a user is logged in, show links to:
    - Create a new post
    - Create a new category
    - Log out
    - View the user's own profile
- Prevent non-logged-in users from viewing:
  - The form to create a new comment
  - Links to edit posts
- Prevent non-logged-in users from accessing:
  - All `posts` actions except `show` and `index`
  - All `comments` actions
  - `categories` `new` and `create` actions
###
- Edit the posts and comments controller to set the creator to the current user (instead of test user).
- Allow registration of a new user.
  - Require a username and password.
  - Username must be unique.
  - Password must be at least 5 characters long.
- Add routes to log in, log out, register a new user, and support all user actions except `index` and `destroy`. Use the following custom routes:
  ```
  get '/register', to: 'users#new'
  ```
- Allow a logged-in user to edit their own profile.
- Prevent users from editing other users' profiles.
- Display a user's posts and comments on the users `show` view.
- Link to the `show` view for a user wherever you have the user name displayed.

## Add password attribute to users 
- Create a new column to store the password digest. It must be called `password_digest` to conform to Rails convention.
  - `rails g migration add_password_digest_to_users`
  ```ruby
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

## Sessions
### Add routes to log in and log out
Use the custom routes specified in the course. We follow Rails convention in the naming of the routes.

Add the following routes to `config/routes.rb`.
```ruby
get '/login', to: 'sessions#new'
post '/login', to: 'sessions#create'
get '/logout', to: 'sessions#destroy'
```

### Add helper methods
- Note: `||=` is used to prevent multiple database queries from being made in one request. The rest of the statement is not executed if `@current_user` is truthy. This technique is known as memoization. 
- Note: `helper_method` makes the methods available in all of the controllers and view templates.
```ruby
# app/controllers/application_controller.rb

class ApplicationController < ActionController::Base
  helper_method :current_user, :logged_in?
  
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  
  def logged_in?
    !!current_user
  end

  def require_user
    if !logged_in?
      flash[:error] = "You must be logged in to do that."
      redirect_to root_path
    end
  end
end
```

### Add session actions 
```ruby
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
    flash[:notice] = "You have successfully logged out."
    redirect_to root_path
  end
end
```

### Add view to log in
```ruby
# app/views/sessions/new.html.erb

<%= render 'shared/header', title: "Log In" %>
<div class='container'>
  <%= form_with(url: '/login', local: true, html: {autocomplete: 'off'}) do %>
    <div class='form-group'>
      <%= label_tag 'username' %>
      <%= text_field_tag(name='username', value='', options={class: 'form-control w-50'}) %>
    </div>
    <div class='form-group'>
      <%= label_tag :password %>
      <%= password_field_tag(name='password', value='', options={class: 'form-control w-50'}) %>
    </div>
    <%= submit_tag(value='Login', options={class: "btn btn-outline-primary mt-3"})%>
  <% end %>
</div>
```

### Edit navigation bar
- Always show links to all posts and all categories.
- If a user is not logged in, show links to:
  - Register (set url to '' for now)
  - Log in
- If a user is logged in, show links to:
  - Create a new post
  - Create a new category
  - Log out
  - View the user's own profile (set url to '' for now)

Update the links section of `app/views/shared/_nav.html.erb` to the following:
```
<!-- Links -->
<ul class='navbar-nav'>
  <li class='nav-item'>
    <%= link_to 'Posts', posts_path, class: 'nav-link' %>
  </li>
  <li class='nav-item'>
    <%= link_to 'Categories', categories_path, class: 'nav-link' %>
  </li>
  <% if logged_in? %>
    <li class='nav-item'>
      <%= link_to 'New Post', new_post_path, class: 'nav-link' %>
    </li>
    <li class='nav-item'>
      <%= link_to 'New Category', new_category_path, class: 'nav-link' %>
    </li>
  <% end %>
</ul>

<ul class='navbar-nav flex-row ml-md-auto d-none d-md-flex'>
  <% if logged_in? %>
    <li class='nav-item'>
      <%= link_to 'Log Out', logout_path, class: 'nav-link' %>
    </li>
    <li>
      <%= link_to 'Profile', '', class: 'nav-link text-right' %>
    </li>
  <% else %>
    <li class='nav-item'>
      <%= link_to 'Register', '', class: 'nav-link' %>
    </li>
    <li class='nav-item'>
      <%= link_to 'Log In', login_path, class: 'nav-link' %>
    </li>
  <% end %>
</ul>
```

### Prevent non-logged-in users from viewing certain elements
- The form to create a new comment
- Links to edit posts

Wrap the pertinent code in `<% if logged_in %>; <% end %>` tags.
```
# app/views/posts/show.html.erb

<% if logged_in? %>
  <section class='w-50 pt-5'>
    <%= form_for [@post, @comment] do |f| %>
      <%= render 'shared/errors', obj: @comment %>
      <div class="form-group">
        <%= f.label :body, "Leave a comment" %>
        <%= f.text_area :body, rows: 3, class: "form-control" %>
      </div>
      <%= f.submit "Create comment", class: "btn btn-outline-primary btn-sm" %>
    <% end %>
  </section>
<% end %>
```

```
# app/views/posts/_post.html.erb

<% if current_user == post.creator %>
  <%= button_to 'Edit', edit_post_path(post), method: 'get', class: 'btn btn-sm btn-outline-secondary border-left-0' %>
<% end %>
```

### Prevent non-logged-in users from performing certain actions
- All `posts` actions except `show` and `index`
- All `comments` actions
- `categories` `new` and `create` actions

Use `before_action :require_user` in the controllers.
```
```

```
```
- Edit the posts and comments controller to set the creator to the current user (instead of test user): `@post.creator = current_user`

### Check your changes.
- Verify that you can log in and log out.
- Verify that certain parts of the UI only show up if the user is logged in.
- Verify that users cannot access certain routes (e.g., `localhost:3000/posts/new`) unless they are logged in.
- Verify that the logged_in user's name is displayed when a new post is created.
- Verify that the logged_in user's name is displayed when a new comment is created.

### Allow a new user to register
- Add validations to `app/models/post.rb` 
  ```ruby
  validates :username, presence: true, uniqueness: true
  validates :password, presence: true, on: create, length: {minimum: 5}
  ```
- Add actions to users controller.
  ```ruby
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

### Add Bootstrap styling
At this point, I give in and finally add styling using [Bootstrap](https://getbootstrap.com/) to my application. I style my app differently than the instructors do. I referred to [this article](https://medium.com/@biancapower/how-to-add-bootstrap-4-to-a-rails-5-app-650118459a1e) for help with installation. I could not get the dropdowns on the navigation bar to work correctly, though, so my configuration may be incorrect.

After styling, my app looks like this:

![](../gifs/postit_lecture_5_add_bootstrap_demo.gif)

### Allow a logged-in user to edit their profile
- Add the following to users controller.
  ```ruby
  before_action :set_user, only: [:show, :edit, :update]
  
  def edit
  end
  
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
- Add a `show` view with a link to the `edit` view.
  ```
  # app/views/users/show.html.erb
  
  <%= render 'shared/header', title: current_user.username, user: true %>
  ```

  ```
  # app/views/shared/_header.html.erb
  
  <% post ||= nil %>
  <% user ||= nil %>
  
  <%= render 'shared/nav' %>
  <section class='jumbotron text-center'>
    <h1 class='jumbotron-heading'><%= title %></h1>
    <% if post %>
      <%= render 'post_url', post: post %>
      <%= render 'shared/creator_details', obj: post %>
    <% elsif user %>
      <%= link_to 'Edit', edit_user_path(current_user.id) %>
    <% end %>
  </section>
  <%= render 'shared/flash' %>
  ```
- Extract the form for a new user to a partial; use the same form for the edit view. The submit button should display `"Update Profile"` in the `edit` view, and `"Register"` in the `new` view: `f.submit(@user.newrecord? ? "Register" : "Update Profile")`
- Check your changes.
  - Log in. Edit the username. Check that the new name shows up in posts and comments created by the user.
  - Edit the password. Log out, then check that you can log back in using the new username and password.

### Prevent users from editing other users' profiles
- Add the following to `app/controllers/users_controller.rb`.
  ```ruby
  before_action :require_same_user, only: [:edit, :update]
  
  def require_same_user
    if current_user != @user
      flash[:error] = 'You are not allowed to do that.'
      redirect_to root_path
    end
  end
  ```
- Check your changes: Log in as one user and attempt to access the edit page of another user.

### Display a user's posts and comments on the users `show` view 
- Edit `show` view.
  ```
  # app/views/users/show.html.erb
  
  <%= render 'shared/header', title: @user.username, user: @user == current_user %>
  
  <section class='container'>
    <% number_of_posts = @user.posts.empty? ? 0 : @user.posts.size %>
    <% number_of_comments = @user.comments.empty? ? 0 : @user.comments.size %>
    
    <ul class='nav nav-tabs'>
      <li class='nav-item'>
        <%= link_to "Posts (#{number_of_posts})", user_path(@user), class: 'nav-link' %>
      </li>
      <li class='nav-item'>
        <%= link_to "Comments (#{number_of_comments})", user_path(@user, tab: 'comments'), class: 'nav-link' %>
      </li>
    </ul>
    
    <% if params[:tab].nil? %>
      <% if @user.posts.empty? %>
        <p class="text-muted">There aren't any posts for this user.</p>
      <% else %>
        <% @user.posts.each do |post| %>
          <%= render 'posts/post', post: post %>
        <% end %>
      <% end %>
    <% elsif params[:tab] == 'comments' %>
      <% if @user.comments.empty? %>
        <p class="text-muted">There aren't any comments for this user.</p>
      <% else %>
        <% @user.comments.each do |comment| %>
          <%= render 'comments/comment', comment: comment, show_post: true %>
        <% end %>
      <% end %>
    <% end %>
  </section>
  ```
- Extract and edit comment partial.
  ```
  # app/views/comments/_comment.html.erb
  
  <% show_post ||= false %>
  
  <article class="card bg-light mb-3" style="max-width: 18rem;">
    <div class="card-body">
      <p class="card-text"><%= comment.body %></p>
      <small class='text-muted'>
      <% if show_post %>
        <%= link_to comment.post.title, post_path(comment.post) %>
      <% end %>
      </small>
      <%= render 'shared/creator_details', obj: comment %>
    </div>
  </article>
  ```
  ```
  # app/views/posts/show.html.erb
  
  <%= render 'shared/header', title: @post.title, post: @post %>
  
  <section class='container justify-content-center'>
    <p><%= simple_format(@post.description) %></p>
    
    <% if logged_in? %>
      <section class='w-50 pt-5'>
        <%= form_for [@post, @comment] do |f| %>
          <%= render 'shared/errors', obj: @comment %>
          <div class="form-group">
            <%= f.label :body, "Leave a comment" %>
            <%= f.text_area :body, rows: 3, class: "form-control" %>
          </div>
          <%= f.submit "Create comment", class: "btn btn-outline-primary btn-sm" %>
        <% end %>
      </section>
    <% end %>
    
    <section class='py-5'>
      <h5 class='pb-2'>Comments</h5>
      <% if @post.comments.empty? %>
        <p class="text-muted">There aren't any comments for this post.</p>
      <% else %>
        <% @post.comments.each do |comment| %>
          <%= render 'comments/comment', comment: comment %>
        <% end %>
      <% end %>
    </section>
  </section>
  ```
### Link to the `show` view for a user wherever you have the user name displayed
```
# app/views/shared/_creator_details.html.erb

<p><small class="text-muted"><%= link_to(obj.creator.username, user_path(obj.creator.id)) + " #{display_datetime(obj.created_at)}" %></small></p>
```

### Demo of user pages
![](../gifs/postit_lecture_5_users_demo.gif)

## Lecture 6
### Instructions
- Allow logged-in users to upvote or downvote once per post and comment. Each vote must belong to a user, and must belong to either a post or a comment.
- Create the routes for the votes as follows:
  - `POST /posts/:post_id/vote => posts#vote`
  - `POST /posts/:post_id/comments/:comment_id/vote => comments#vote`

### Create vote model
- Create table.
  - `rails g migration create_votes`
  ```ruby

  class CreateVotes < ActiveRecord::Migration[6.0]
    def change
      create_table :votes do |t|
        t.boolean :vote
        t.belongs_to :user
        t.string :voteable_type
        t.integer :voteable_id
        t.timestamps
      end
  
      add_index :votes, [:voteable_type, :voteable_id]
    end
  end
  ```
  - `rails db:migrate`
- Define model.
  ```ruby
  # app/models/vote.rb 
  
  class Vote < ApplicationRecord
    belongs_to :creator, class_name: 'User', foreign_key: 'user_id'
    belongs_to :voteable, polymorphic: true
  end
  ```
- Set up polymorphic association in `app/models/post.rb` and `app/models/comment.rb`.
  `has_many :votes, as: :voteable`
- Check your changes in `rails console`.
  ```
  # Create a new vote: user 1 upvoted on post 2.
  Vote.create(user_id: 1, vote: true, voteable: Post.find(2))
  
  # Create a new vote: user 1 upvoted on comment 1.
  Vote.create(user_id: 1, vote: true, voteable: Comment.find(1))
  
  # Create a new vote: user 2 downvoted on post 2.
  Vote.create(user_id: 2, vote: false, voteable: Post.find(2))
  
  pp Post.find(2).votes # should print two votes
  pp Comment.find(1).votes # should print one vote
  pp User.find(1).votes # should print two votes 
  pp User.find(2).votes # should print one vote 
  ```

### Create vote routes 
Modify the post routes block in `config/routes.rb` to the following.
```ruby
resources :posts, except: :destroy do
  member do
    post 'vote'
  end

  resources :comments, only: :create do
    member do
      post 'vote'
    end
  end
end
```

### Allow a user to vote on a post 
- Add up arrows and down arrows that trigger the vote actions.
  ```
  # app/views/posts/_post.html.erb 
  
  <aside class='col-md-2 votes text-center'>
    <%= link_to vote_post_path(post, vote: true), method: 'post' do %>
      <%= fa_icon 'arrow-up' %>
    <% end %>
    </br>
    <%= post.total_votes %>
    </br>
    <%= link_to vote_post_path(post, vote: false), method: 'post' do %>
      <%= fa_icon 'arrow-down' %>
    <% end %>
  </aside>
  ```
- Define a `vote` action in PostsController.
  - [NOTE](https://guides.rubyonrails.org/5_0_release_notes.html#action-pack-deprecations): `redirect_to :back`, which is used in the videos, was deprecated in Rails 5.0 in favor of `redirect_back`.
  ```ruby
  # app/controllers/posts_controller.rb
  
  before_action :set_post, only: [:show, :edit, :update, :vote]
  
  def vote
    Vote.create(voteable: @post, creator: current_user, vote: params[:vote])
    redirect_back fallback_location: root_path
  end
  ```

### Allow a user to vote on a comment
- Add up arrows and down arrows that trigger the vote actions.
  ```
  # app/views/comments/_comment.html.erb 
  
  <aside class='col-md-2 votes text-center'>
    <%= link_to vote_post_comment_path(comment.post, comment, vote: true), method: 'post' do %>
      <%= fa_icon 'arrow-up' %>
    <% end %>
    </br>
    <%= comment.total_votes %>
    </br>
    <%= link_to vote_post_comment_path(comment.post, comment, vote: false), method: 'post' do %>
      <%= fa_icon 'arrow-down' %>
    <% end %>
  </aside>
  ```
- Define a `vote` action in CommentsController.
  ```ruby
  # app/controllers/comments_controller.rb
  
  def vote
    @comment = Comment.find(params[:id])
    Vote.create(voteable: @comment, creator: current_user, vote: params[:vote])
    redirect_back fallback_location: root_path
  end
  ```

### Display total votes on posts and comments
- Define instance methods on the Post and Comment models.
  ```ruby
  def total_votes
    self.upvotes - self.downvotes  
  end
  
  def upvotes
    self.votes.where(vote: true).size
  end
  
  def downvotes
    self.votes.where(vote: false).size
  end
  ```
- Add `<%= post.total_votes %>` to `app/views/posts/_post.html.erb`.
- Add `<%= comment.total_votes %>` to `app/views/comments/_comment.html.erb`.

### Display posts in decreasing order of upvotes
Modify the `index` action in PostsController to the following:
```ruby
def index
  @posts = Post.all.sort_by{|x| x.total_votes}.reverse
end
```

### Restrict user to one vote per object 
- Add `validates_uniqueness_of :creator, scope: :voteable` to Vote model. 
- Check your changes in `rails console`.
  ```
  # Create a new vote: user 1 upvoted on post 2.
  Vote.create(user_id: 1, vote: true, voteable: Post.find(2))
  # Run the above again. You should see `rollback transaction`.
  
  # Create a new vote: user 1 upvoted on comment 1.
  Vote.create(user_id: 1, vote: true, voteable: Comment.find(1))
  # Run the above again. You should see `rollback transaction`.

  # Create a new vote: user 2 downvoted on post 2.
  Vote.create(user_id: 2, vote: false, voteable: Post.find(2))
  # Run the above again. You should see `rollback transaction`.
  
  pp Post.find(2).votes # should print two votes
  pp Comment.find(1).votes # should print one vote
  pp User.find(1).votes # should print two votes 
  pp User.find(2).votes # should print one vote 
  ```
- Check your changes in the UI.

### Additional changes (not specified in course videos)
I added these features because I thought it made for a better user experience.
- Disable voting and gray out the arrow corresponding to the vote the user has made on the comment or post. 
- Allow a user to change their vote on a comment or post. I update the appropriate row in the votes table when the user changes their vote (no additional rows are created).
- Extract the voting functionality to a partial.
- Do not sort by total votes created because it's disconcerting when you vote on a post and it moves. I sort the posts in decreasing order of when it was created (oldest posts first). `@posts = Post.all.sort_by{|x| x.created_at}`

```ruby
# app/views/shared/_vote.html.erb

<% if obj.class == Post %>
  <% url_true = vote_post_path(obj, vote: true) %>
  <% url_false = vote_post_path(obj, vote: false) %>
<% elsif obj.class == Comment %>
  <% url_true = vote_post_comment_path(obj.post, obj, vote: true) %>
  <% url_false = vote_post_comment_path(obj.post, obj, vote: false) %>
<% end %>

<% if !current_user || obj.votes.where(user_id: current_user.id, vote: true).empty? %>
  <%= link_to url_true, method: 'post' do %>
    <%= fa_icon 'arrow-up' %>
  <% end %>
<% else %>
  <%= fa_icon 'arrow-up', class: 'disabled' %>
<% end %>
</br>
<%= obj.total_votes %>
</br>
<% if !current_user || obj.votes.where(user_id: current_user.id, vote: false).empty? %>
  <%= link_to url_false, method: 'post' do %>
    <%= fa_icon 'arrow-down' %>
  <% end %>
<% else %>
  <%= fa_icon 'arrow-down', class: 'disabled' %>
<% end %>
```

```ruby
# app/views/posts/_post.html.erb
# only the relevant code is shown

<aside class='col-md-2 votes text-center'>
  <%= render 'shared/vote', obj: post %>
</aside>
```

```ruby
# app/views/comments/_comment.html.erb
# only the relevant code is shown

<aside class='col-md-2 votes text-center'>
  <%= render 'shared/vote', obj: comment %>
</aside>
```

```ruby
# app/controllers/posts_controller.rb
# only the relevant code is shown
def vote
  existing_votes = @post.votes.where(user_id: current_user.id)
  if existing_votes.empty?
    Vote.create(voteable: @post, creator: current_user, vote: params[:vote])
  else
    existing_votes.first.update(vote: params[:vote])
  end
  redirect_back fallback_location: root_path
end
```

```ruby
# app/controllers/posts_controller.rb
# only the relevant code is shown
def vote
  @comment = Comment.find(params[:id])
  existing_votes = @comment.votes.where(user_id: current_user.id)
  if existing_votes.empty?
    Vote.create(voteable: @comment, creator: current_user, vote: params[:vote])
  else
    existing_votes.first.update(vote: params[:vote])
  end
  redirect_back fallback_location: root_path
end
```

### Deployment Notes
I did all of the following and my deployment was successful, but my app still crashes. I'll have to come back to this another time.

#### How to migrate from sqlite to postgres 
https://devcenter.heroku.com/articles/sqlite3#running-rails-on-postgres

#### How to update your rbenv ruby version
This is a condensed version of this [article](https://www.aloucaslabs.com/miniposts/how-to-update-your-rbenv-ruby-version).
1. What is the latest stable release? [LINK](https://www.ruby-lang.org/en/downloads). At the time of writing this, it is 2.6.5.
2. ` cd ~/.rbenv/plugins/ruby-build/ && git pull`
3. Install it: `rbenv install 2.6.5`
4. Set it to be the global ruby version of the system: `rbenv global 2.6.5`
  - NOTE: I had this output when I ran `rbenv versions`, so I navigated to `/home/nancy/.ruby-version` and changed the contents of the file to `2.6.5`.
  ```
  system
* 2.5.3 (set by /home/nancy/.ruby-version)
  2.6.5
  ```
5. Rehash rbenv to install shims for all Ruby executables known to rbenv: `rbenv rehash`
6. Check the ruby version. `ruby -v` It should be 2.6.5.

#### How to update RubyGems
`gem update --system`

#### How to update bundler
`gem install bundler`

### How to update ruby version in the app
- Change it in `Gemfile` and `.ruby-version`.
- Run `bundle install`.

### Deployment was successful but my app crashes
Did you remember to migrate your database?
`heroku run rake db:migrate`
Are you still getting errors?
`heroku run rails console` may give you more illuminating error messages.
