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
