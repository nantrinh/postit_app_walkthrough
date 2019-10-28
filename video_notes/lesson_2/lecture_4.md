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