# Lesson 3
## Lecture 5 
### Part 1
- 53:00: review quiz 2
- 41:10: asset pipeline is a way to obfuscate and compress static assets when we deploy our application to production.
- 38:30: what is obfuscation and why use it
- 35:30: how to obfuscation works
- 34:30: cache buster
- 33:40: the problem with caching aggressively
- 31:40: manifest file
- 31:30: sprockets
- 28:42: scss file 
- 19:40: precompiling makes deployment faster but could be the source of bugs
- 19:00: why use has_secure_password instead of a gem
- 18:00: devise comes with the kitchen sink
- 15:36: how passwords are saved; digression
- 14:25: how passwords should be saved; an application should not know what your password is
- 14:00: one-way hash
- 12:20: password digest migration
- 11:00: dictionary attacks
- 9:40: bcrypt-ruby
- 3:34: there is no getter for the password
- 2:50: authenticate method

### Part 2
- 48:05: added actions to users controller
- 42:35: update user model
- 37:30: update routes
- 36:00: sessions controller
- 34:00: sessions new view
- 32:40: sessions create action
- 24:50: save the user id, NOT the user object because cookies have a 4KB size limit. As the user performs more actions, the user object will grow and you may get an overflow error.
- 22:35: sessions create and destroy actions defined
- 22:00: edit navigation partial
- 19:35: expose `:current_user` and `:logged_in?` as helper methods in application controller 
- 18:15: define `current_user` method in application controller
- 12:00: make `current_user` method more performant; hit the database once for each request
- 9:30: control who can do which actions
- 6:30: set user id to authenticated user in the controllers
- 5:00: recap

## Lecture 6
### Part 1
- 46:00: subject: user_id. object: post_id, photo_id, or video_id. the comment can be for either a post, photo, or video.
- 45:00: this way of doing it is not great because there are too many empty cells.
- 43:30: have a column for id, and one column to identify the thing you are tracking (e.g., is it a post, photo, or video?)
- 42:45: id, body, user_id, commentable_type, commentable_id (rails convention is *able_type and *able_id). commentable_type is a string (e.g., "Image", "Post").
- 41:33: composite foreign key: commentable_type and commentable_id together form a foreign key.
- 39:08: ERD with votes 
- 36:20: create votes table migration 
    ```
    def change
      create_table :votes do |t|
        t.boolean :vote
        t.integer :user_id
        t.string :voteable_type
        t.integer :voteable_id
        t.timestamps
      end
    end
    ```
- 34:10: create vote model 
    ```
    class Vote < ActiveRecord::Base
      belongs_to :creator, class_name: 'User', foreign_key: 'user_id'
    end
    ```
- 31:13: set up polymorphic association in vote model (the M side of 1:M)
    ```
    belongs_to :voteable, polymorphic: true
    ```
- 29:32: set up polymorphic association on the 1 side (of 1:M)
    `has_many :votes, as: :voteable` in posts and comments models
- 28:10: checking in rails console 
- 21:55: add up arrow and down arrows to upvote and downvote comments
    ```
    <% link_to '' do %>
      <i class='icon-arrow-up'></i>
    <% end %>
    <% link_to '' do %>
      <i class='icon-arrow-down'></i>
    <% end %>
    ```
- 18:00: need a route. could route to POST /votes => 'VotesController#create' 
- 16:00: alternatively, could route to POST /posts/3/vote => 'PostsController#vote' and same for comments
- 14:00: the second way will be demonstrated, partly for teaching reasons. if you're going to have votes for many types of things, the first way would be better.
- 12:30: using `member`. the created route would be `POST /posts/:id/vote posts#vote`. you use this if you will be working with members of the class.
    ```
    resources :posts, except: [:destroy] do
      member do
        post :vote
      end

      resources :comments, only: [:create]
    end
    ```
- 10:00: you would use `collection do; get :archives; end` if you were not going to pass in an object in the route: `GET /posts/archives posts#archives`
- 3:00: 
    ```
    <% link_to vote_post_path(post), method: 'post' do %>
      <i class='icon-arrow-up'></i>
    <% end %>
    <% link_to '' do %>
      <i class='icon-arrow-down'></i>
    <% end %>
    ```

### Part 2
- 41:14: data-method attribute; javascript file that uses it. this is why you can write a link that can use POST or DELETE.
- 33:55: how to pass in params using link_to  
  `<% link_to vote_post_path(post, vote: true), method: 'post' do %>`
- 30:00: define vote action in posts controller
  ```
  # add :vote to before_action 

  def vote
    @vote = Vote.create(voteable: @post, creator: current_user, vote: params[:vote])

    if @vote.validi?
      flash[:notice] = "Your vote was counted."
    else
      flash[:error] = "Your vote was not counted."
    end

    redirect_to :back
  end
  ```
- 22:30: display (number of upvotes - number of downvotes). since this is business logic, put it in the post model.
  ```
  def total_votes
    up_votes - down_votes
  end

  def up_votes
    self.votes.where(vote: true).size
  end

  def down_votes
    self.votes.where(vote: false).size
  end
  ```
- 16:40: sort posts in index view to display posts in decreasing order of (number of upvotes - number of downvotes).
  ```
  def index
    # NOTE/TODO: it would be safer to retrieve a subset because
    # you might have a very large number of Post records
    @posts = Post.all.sort_by {|x| x.total_votes}.reverse
  end
  ```
- 14:00: how to only count each user's vote once: add validation to vote model. 
  `validates_uniqueness_of :creator, scope: :voteable`
- 9:00: rails escapes all tags by default
- 7:10: you can use `html_safe` to tell rails you don't want to escape the tags. `flash[:error] = "some string".html_safe`
