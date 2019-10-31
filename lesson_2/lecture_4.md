# Lecture 4

This document follows along with Lesson 2, Lecture 4 of the Launch School 5301 Rails Course. There are some differences in the implementations but the main ideas are the same. I used Rails 6 and Ruby 2.5.3. I did not use Twitter Bootstrap.

## Instructions
- Allow a user to create a new comment on a post.
  - The form for a new comment should be displayed on the posts `show` view.
  - The form should be submitted via a POST request to `/posts/:post_id/comments`.
- Add the following validations for a new comment. Display validation errors in the posts `show` view.
  - Require `body`.
- Display all comments related to a post on the posts `show` view.

## Allow a user to create a new comment 
- Add `create` action. For now, set the default user to "Test". 
  ```
  # app/controllers/comments_controller.rb 
  
  class CommentsController < ApplicationController
    def create
      @post = Post.find(params[:post_id])
      @comment = Comment.new(comment_params)
      @comment.post = @post
  
      @user = User.find_by username: "Test"
      @comment.user = @user
  
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
  ```
  # config/routes.rb

  Rails.application.routes.draw do
    resources :categories, except: :destroy
  
    resources :posts, except: :destroy do
      resources :comments, only: :create
    end
  end
  ```
- Add new comment form to posts `show` view.
  ```
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
- Add `validates :body, presence: true` to `app/models/comments.rb`
- Add `<%= render 'shared/errors', obj: @comment %>` to `app/views/posts/show.html.erb`

### New comment
On the show post page, display a model backed comment creation form. You'll need to modify the routes to support a nested comment creation url (eg, HTTP POST request to /posts/:post_id/comments), create a CommentsController#create action, and figure out which template to render when there's a validation error. See the sample solution for the workflow: tl-postit.herokuapp.com (navigate to the show post page after logging in).

This is putting knowledge of nested resources and model backed forms together.
- Add `create` action.
- Add nested route.
- 
### Select categories on new/edit post form
On the post form, expose either a combo box or check boxes to allow selection of categories for this post. Hint: use the category_ids virtual attribute.

### Show Category page 
After your posts are associated with categories, display the categories that each post is associated with. When clicking on the category, take the user to the show category page where all the posts associated with that category are displayed. Look at the sample app for workflow ideas, but feel free to be creative!

### Helpers
Use Rails helpers to fix the url format as well as output a more friendly date-time format.
