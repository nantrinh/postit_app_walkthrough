# Instructions

## Lecture 1
- Allow a user to create a new post. Use a model-backed form.
- Add the following validations for a new post.
  - title is required. minimum length of 5. 
  - url is required. must be unique.
  - description is required.
- Display validation errors on the template.
- Allow a user to update a post. Use a model-backed form.
- Extract the template used for the new, create, edit, and update actions to a partial.
- Add actions and views to allow a user to create a new category. Use a model-backed form.
- Extract the part of the category and post forms that displays validation errors to a partial.

### Create a test user.
In rails console, run `User.create(username: "Test")`

### Allow a user to create a new post. 

#### Edit PostsController. For now, set the default user to "Test".
```
# app/controllers/posts/controller.rb

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

#### Create a form.
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

#### Add flash notice display to `/posts` route
```
<% if flash[:notice] %>
  <div><%= flash[:notice] %></div>
<% end %>
```

#### Test your changes
- Create a new post.
- Check in rails console to see if the post was created: `pp (User.find_by username: "Test").posts.all`

### Add validations.
```
# app/models/post.rb

class Post < ActiveRecord::Base
  belongs_to :creator, class_name: "User", foreign_key: "user_id"
  has_many :comments, dependent: :destroy
  has_many :post_categories, dependent: :destroy
  has_many :categories, through: :post_categories

  validates :title, presence: true, length: {minimum: 5}
  validates :url, presence: true
  validates :description, presence: true
end
```

### Display validation errors in the `new` template.
Note: `form_with` submits forms using Ajax by default. To follow along with the exercise in class, disable this behavior by setting the `local` option to `true`. 
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
```

#### Test your changes
- Try to submit a new post with inputs that trigger all of the validation errors, then change the inputs incrementally to pass each of the validations in turn.
- Check that the error messages show up in the view as intended.

### Allow a user to create a new post. 

#### Edit PostsController.
```
# 
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
      render :show
    end
  end

  # code omitted for brevity
end
```

### Add a view for the `edit` action.
```
# `app/views/posts/edit.html.erb` 


```

### Edit 

## Lecture 2
### New comment
On the show post page, display a model backed comment creation form. You'll need to modify the routes to support a nested comment creation url (eg, HTTP POST request to /posts/:post_id/comments), create a CommentsController#create action, and figure out which template to render when there's a validation error. See the sample solution for the workflow: tl-postit.herokuapp.com (navigate to the show post page after logging in).

This is putting knowledge of nested resources and model backed forms together.

### Non model backed form helpers
Play around with the form helpers (ie, non-model backed forms) and see how those helpers can be useful when you are not working with an ActiveRecord model. This scenario comes up quite often in any webapp.

Model backed forms are useful when performing "CRUD" actions on a resource, and non-model backed form helpers are used everywhere else. We'll get to use it in our application later when we implement authentication. For now, play around with them and see how they differ from model-backed form helpers.

### Select categories on new/edit post form
On the post form, expose either a combo box or check boxes to allow selection of categories for this post. Hint: use the category_ids virtual attribute.

### Show Category page 
After your posts are associated with categories, display the categories that each post is associated with. When clicking on the category, take the user to the show category page where all the posts associated with that category are displayed. Look at the sample app for workflow ideas, but feel free to be creative!

### Helpers
Use Rails helpers to fix the url format as well as output a more friendly date-time format.
