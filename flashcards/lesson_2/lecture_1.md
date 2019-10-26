# What does the `label` element do?
---
Screen readers read the text in the label tag to let the user know what text is associated with an input element. This is very useful for the vision-impaired.

Example of how it would be used within a form:
```
<label for="title">Input a title</label>
<input id="title" name="title" type="text">
```
The screen reader would read "Input a title".

It is also a nice usability feature. When you click on the label, the browser focuses on the input.
(Source: Lecture 3 Part 1 Video, -26:00)

# Would you ever want to create a pure html form in Rails? Why or why not?
---
No, because you would have to comment out `protect_from_forgery`.

# What does protect_from_forgery do?
---
TODO

# What happens when you submit a form to create a new Post object in the ffollowing case? Suppose you have an appropriate controller and view for the `new` route.
```
# app/controllers/posts_controller.rb

class PostsController < ApplicationController
  def create
    @post = Post.create(params[:post])
  end
end
```
---
You get ActiveModel::ForbiddenAttributesError in PostsController#create.
This is due to the [strong parameters security practice](https://guides.rubyonrails.org/v6.0/action_controller_overview.html#strong-parameters). Parameters are forbidden to be used in Active Model mass assignments unless explicitly permitted. This helps prevent accidentally users to update sensitive model attributes.

Parameters can also be marked as required and will result in a 400 Bad Request being returned if not all required parameters are passed in.

# For the `create` action, How do you require a `post` key in the params and permit a `title` and `url` to be passed in?
---
TODO: this doesn't create a new row in the db!! Why?
```
class PostsController < ApplicationController
  def create
    @post = Post.create(post_params)
  end

  private

  def post_params
    params.require(:post).permit(:title, :url)
  end
end
```

# How do you require a title attribute when creating a new post?
---
TODO

# How can you use mass assignment? How do you work with strong params? 

(Source: Lecture 3 Part 1 Video, -9:40) Explanation of strong params
(Source: Lecture 3 Part 1 Video, -7:50) How to work around 

# What happens when you submit a value in a form for a param that is not permitted? For example, if you only permit title and the user submits title and url?
---
"Unpermitted parameters: url" is printed in the console. No exception is thrown. This can be a source of silent bugs in your app. But you don't want to tell a hacker that their hacking has failed. You want silently counter their malicious act.
(Source: Lecture 3 Part 1 Video, -5:33)

You can only use attributes or virtual attributes as labels and text field params when using model-backed form helpers.

# Validations are always added to the ______ layer.
---
Model.

# Suppose you had the following files:
TODO
```
# app/views/posts/new.html.erb

<h4>Rails model-backed form example</h4>
<%= form_for @post do |f| %>
  <%= f.label :title %>
  <%= f.text_field :title %>
  <br/>

  <%= f.label :url %>
  <%= f.text_field :url %>
  <br/>
  <%= f.submit "Create Post" %>
<% end %>
```

```
```

# How do the 7 default Rails actions map to CRUD?
---
- Create: new, create
- Retrieve: index, show
- Update: edit, update
- Delete: destroy

# What is the difference between `render` and `redirect`?
---
Render compiles the template into HTML and sends the HTML back as part of the response.

Redirect sends a URL as part of the response; there's no HTML in a redirect.
Most browsers follow the redirected URL automatically, and a new request is issued. All redirects will eventually lead to rendering of some template, otherwise your browser will display a "too many redirects" error.

# Why does the URL stay at /posts when there's a validation error? Shouldn't it be /posts/new?
---
The request URL is what's showing up in the address bar, not the response. The response is processed by your browser. The request URL is shown in the address bar.

In the case of a new post form submission, the request URL is /posts. This has nothing to do with the response sent back. The URL only changes on successful post creation because in that case the response is a redirect, and your browser issues a new request, which changes the address bar.

### TODO: Content from Quiz 2 

 
