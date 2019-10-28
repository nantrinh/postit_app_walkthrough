# Lecture 2

This document follows along with Lesson 2, Lecture 4 of the Launch School 5301 Rails Course. There are some differences in the implementations but the main ideas are the same. I used Rails 6 and Ruby 2.5.3. I did not use Twitter Bootstrap.

## Instructions

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
