# For every form input, an id attribute is generated from its _____.
---
name
For example if you have `<%= check_box_tag(:pet_cat) %>` in your form, you will get `<input type="checkbox" name="pet_cat" id="pet_cat" value="1"/>` in your HTML.

# All forms using `form_with` implement `remote: true` by default. These forms will submit data using an __________ request. How do you disable this?
---
XHR (Ajax); include `local: true`

# What is `flash` in Rails?
---
https://api.rubyonrails.org/classes/ActionDispatch/Flash.html

The flash provides a way to pass temporary primitive-types (String, Array, Hash) between actions. Anything you place in the flash will be exposed to the very next action and then cleared out.

This is a great way of doing notices and alerts, such as a create action that sets flash[:notice] = "Post successfully created" before redirecting to a display action that can then expose the flash to its template. Actually, that exposure is automatically done.

```
class PostsController < ActionController::Base
  def create
    # save post
    flash[:notice] = "Post successfully created"
    redirect_to @post
  end

  def show
    # doesn't need to assign the flash notice to the template, that's done automatically
  end
end

show.html.erb
  <% if flash[:notice] %>
    <div class="notice"><%= flash[:notice] %></div>
  <% end %>
```
