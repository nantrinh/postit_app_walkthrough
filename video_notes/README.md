# Video Notes

This repo contains timestamped notes for select videos. I created these so I could easily navigate to the certain parts of the videos when looking to clarify a certain concept.

The timestamps are in `length_of_video - where_you_are_in_the_video` format, because that is what is displayed in the Launch School video controller and thus easier for me to jot down as I watch the videos.

# Table of Contents
* [Lesson 1](#lesson-1)
   * [M:M Association Solution](#mm-association-solution)
* [Lesson 2](#lesson-2)
   * [Lecture 3](#lecture-3)
      * [Part 1](#part-1)
      * [Part 2](#part-2)
   * [Lecture 4](#lecture-4)

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
