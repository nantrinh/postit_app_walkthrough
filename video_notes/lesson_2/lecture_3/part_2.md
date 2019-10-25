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
