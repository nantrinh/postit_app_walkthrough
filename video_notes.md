# Video Notes

This document contains timestamped notes for select videos. I created these so I could easily navigate to the certain parts of the videos when looking to clarify a certain concept.

The timestamps are in `length_of_video - where_you_are_in_the_video` format, because that is what is displayed in the Launch School video controller and thus easier for me to jot down as I watch the videos.

# Table of Contents
* [Lesson 1](#lesson-1)
   * [M:M Association Solution](#mm-association-solution)
* [Lesson 2](#lesson-2)
   * [Lecture 3](#lecture-3)
      * [Part 1](#part-1)
      * [Part 2](#part-2)
   * [Lecture 4](#lecture-4)
* [Lesson 3](#lesson-3)
   * [Lecture 5](#lecture-5)
      * [Part 1](#part-1-1)
      * [Part 2](#part-2-1)
   * [Lecture 6](#lecture-6)
      * [Part 1](#part-1-2)
      * [Part 2](#part-2-2)
* [Lesson 4](#lesson-4)
   * [Lecture 7](#lecture-7)

Created by [gh-md-toc](https://github.com/ekalinin/github-markdown-toc)

# Lesson 1
## M:M Association Solution
Main Idea:  How to support a many to many association using `has_many: through`

- 18:46: ERD Diagram
- 17:55: `rails generate migration create_categories`
- 16:50: create category model
- 16:30: checking in rails console that the category table was created and "linked up" correctly to a model: when we see that rails inferred columns correctly
- 15:58: example of checking in rails console for nonexistent table, even though model file exists
- 15:10: `"PostCategory".tableize`
- 14:28: `rails generate migration post_categories`
- 13:07: set up 1:M association between Post and PostCategory
- 9:40: checking the 1:M association between Post and PostCategory in rails console
- 7:42: set up category model
- 6:22: checking the 1:M association between Category and PostCategory in rails console
- 4:45: set up `has_many: through` associations between post and category, through post_categories
- 4:15: checking the M:M assocations in rails console

# Lesson 2

## Lecture 3
### Part 1
- 26:00: what the `label` element is used for
- 21:40: how the `form_for` method works
- 9:40: explanation of strong params
- 7:50: how to work around strong params
- 5:33: what happens when you submit a value in a form for a param that is not permitted. for example, if you only permit title and the user submits title and url.

### Part 2
- 54:50: validations go in the model layer
e.g.,`validates :title, presence: true` 
- 53:30: validations are triggered when you try to save to the database 
- 52:56: you can use the `errors.full_messages` chained methods to view an array of error messages. 
    ```
    # suppose we have a validation for the presence of the title param
    # suppose we run these commands in the rails console
    post = Post.new(url: "google.com"
    post.save # this would trigger an error 
    post.errors.full_messages # this would return `["Title can't be blank"]`
    ```
- 44:00: displaying error messages in `new` view
- 44:34: a div with `field_with_errors` class is automatically added to your form, wrapping the fields that triggered the errors
- 41:30: how do model-backed forms automatically know the url 
- 36:49: an input element with `name="_method type="hidden" value="patch"` in a hidden div 
- 36:00: rails uses the value for the `"_method"` key in the `params` hash to determine what http method to use. this is how rails can use a http method like `patch`.
- 35:55: most browsers do not support all the http methods, so rails does it this way to work around it. rails does not have to write in logic to deal with the variance in http method support by different browsers.
- 32:20: create edit view; use partials
- 23:56: `before_action`
- 21:00: why use `before_action`
- 15:39: example of special cases to handle
- 15:00: create comment form on show page
- 13:50: hint 1 on how to handle the flow 
- 4:20: redirect -> URL (use named route). render -> template file (use a string).

## Lecture 4
- 1:01:17: nested resource with nested comment
- 1:00:13: new comment form is on the show post page
- 59:53: comments controller
- 58:40: comments are submitted to /posts/:post_id/comments
- 55:20: add validation for presence of body
- 54:00: display comment validation errors in view
- 53:30: if you ever wonder where the errors are saved, check the controller
- 51:47: putting shared templates in `shared` folder is Chris's habit, not Rails convention
- 45:54: associate your created comments with a user
- 45:42: why have nested resources?
- 45:00: url design when doing your mockup. we want a url that looks like `/posts/2` instead of `/comments/2`. when you have a lot of ajax though, the urls are hidden from you.
- 40:30: we want to manipulate data at presentation time rather than in the database. when displaying the url, if the url starts with "http://", just use it, otherwise prepend with "http://"
- 39:00: should extract presentation level logic to helpers
- 37:32: use of application helper `<%= link_to @post.title, fix_url(@post_url) %>`
- 35:00: fat model, thin controller
- 25:00: how to assign multiple categories to a post in one command
- 22:30: `post.category_ids = [2, 3]` in rails console 
- 20:00: rails select and checkboxes are convoluted
- 17:15: need a value attribute in your options or nothing will be submitted
- 13:20: name has to end with empty brackets according to rails convention 
- 11:00: getting category_ids under post nested structure using naming convention `<select name="post[category_ids][]" multiple="multiple">`
- 6:30: check boxes helper solution 
- 6:20: have the solution in html that you want, then play around with helpers to generate the html 
- 4:00: don't worry about the last empty string in params submission when you are doing mass assignment `"category_ids" => ["2", "3", ""]` 
- 3:00: to permit category_ids explicitly, do `params.require(:post).permit(:title, :url, :description, category_ids: [])`. this is strong parameter syntax. you can also use `permit!` to permit everything

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

# Lesson 4
## Lecture 7
### Solution: Ajax for Post voting
- 17:15: we want to use AJAX when we vote so we don't have to hit the database again many times to display all of the posts and the votes. we want to update only the post that was voted on.
- 16:20: unobtrusive javascript way example. modify application.js. add event listener.  
- 14:55: rails way. add `remote: true` so you will have `<% link_to vote_post_path(post, vote: true), method: 'post', remote: true do %>` 
- 14:20: you will have an attribute `data-remote="true"`
- 13:45: javascript that comes with rails sees `data-remote="true"` and will submit the request as an ajax request
- 10:40: modifying the vote action in the postscontroller
```
respond_to do |format|
  format.html do
    if vote.valid?
      flash[:notice] = 'Your vote was counted.'
    else
      flash[:error] = 'You can only vote on a post once.'
    end
    redirect_to :back # this line was moved up here at 8:30 
  end
  format.js
  # you could have `format.js do; render json: @post.to_json`
  # but since we are using the rails-flavored ajax, we can leave it blank.
  # when we leave this blank, rails will try to render a template of
  # the same name as the action (`vote.js.erb`).
end
```
- 9:30: the template would be `app/views/posts/vote.js.erb`
- 8:43: if you put `redirect_to :back` at the end of the `respond_to do; end` block, you get an error because you would be trying to render a template (the js one), and redirecting. you can do either but not both.
- 7:35: the templates have access to any instance variables you set up in the action
- 6:22: dynamically create ids for the element that you want to affect with javascript: `<span id='post_<%=post.id%>_votes'><%= post.total_votes %> votes</span>`
- 5:00: `$('#post_<%= @post.id %>_votes').html('<% @post.total_votes %> votes')`
- 4:00: Add `remote: true` to the downvote link_to options to ajax-ify downvote action.
- 1:50: Make `vote` an instance variable `@vote` so you can reference it in the template.
- 1:45:
```
<% if @vote.valid? %>
  $('#post_<%= @post.id %>_votes').html('<% @post.total_votes %> votes')
<% else %>
  alert('You can only vote on a post once.');
<% end %>
```

### Solution: Ajax for Comment voting 
- 6:45: setting `remote: true`
- 5:50: setting up `respond_to` block
- 4:00: dynamic ids for total votes
- 2:25: making `comment` and instance variable in the action
- 2:00: add code to the template (similar to what was added for the post.js template)
- 1:00: show validation error 

### Solution: Post Slugs
- 17:50: we don't want to expose the ids of our data or how many of them we have (e.g., 4 categories)
- 17:45: we want our urls to be SEO friendly and informative to the user (e.g., categories/sports instead of categories/1
- 16:00: add column `slug` to users, posts, and categories tables
```
rails g migration add_slugs

def change
  add_column :users, :slug, :string
  add_column :posts, :slug, :string
  add_column :categories, :slug, :string
end
```
- 13:30: add method to post model
```
def generate_slug
  self.slug = self.title.gsub(" ", "-").downcase
end
```
- 12:40: active record callbacks
- 11:00: `before_save :generate_slug`
- 10:10: difference between before_save and before_create: before_create only fires once in the lifecycle of the object. before_save fires every time you save the object. if you want the slug to remain the same when the title is updated, use before_create. if you want to change the slug when the title changes, use before_save. note that if you have bookmarked the url with a previous title, the link would not work anymore.
- 8:30: `Post.all.each {|post| post.save}` in rails console to generate slugs for each post in your database. note that if you have any posts that don't pass validations, they won't be saved, and the slugs won't be generated. check for rollbacks to see if there were any posts that didn't pass validations.
- 6:00: override the `to_param` method to return the slug, so that post_path(post) would use the slug column to build the url
```
# app/models/post.rb

def to_param
  self.slug
end
```
- 4:30: update `set_post` in PostsController: `@post = Post.find_by slug: params[:id]`
- 3:12: update `create` action in CommentsController: `@post = Post.find_by slug: params[:id]`
- 2:24: update `@post.comments.each` to `@post.reload.comments.each` in posts#show view, because when you have a validation error, you want to reload hte post and then grab the comments associated with it
- 1:15: in the ids identifying a post's total votes, change `post.id` to `post.slug`. do the same for comments.

### Solution: User and Category Slugs

