# Lesson 4
At the end of the lesson, the app will [TODO]

Demo:
![](../gifs/lesson_4.gif)

## Course Instructions
### Ajax-ify Voting
When an object is voted on, refresh the total votes shown for the object, not the entire page.

### Use Slugs
- URLs should contain the title of posts, usernames of users, and names of categories, instead of ids.
- Replace all non-alphanumeric characters with a dash, and with multiple dashes in a row with a single dash
- Append a number to a new slug if it is identical to an existing one.

### Voteable gem
- Make it a gem
### Sluggable gem 
### Roles
- Restrict creation of categories to admin role.
- Only show the link to create a new category to admins.
- Restrict editing of posts to their creator and admins.
### Time Zones
- Add a drop-down of time zones to the user form (new and edit).
- Make the default time zone Eastern US time.
- Allow each user to select their time zone.

## What I Changed
### Ajax-ify Voting
In the previous lesson, I added code to handle the following scenarios:
  - If a user has already voted, I gray out the arrow corresponding to the vote the user made on the object, and do nothing if the user clicks on it (it's not even a link anymore, just an icon).
  - If a user has already voted, I allow the user to change their vote. If they click on the other arrow, I update their vote in the database. I do not create a new vote.
Because of these changes, my code deviates from that in the course videos.

### Use Slugs
I do not add the extra functionality from -11:35 in the Better Slugs solution video. 


## What I Added

## Lecture 7
### Ajax-ify Voting
#### Modify the `vote` actions to serve the Ajax request
Replace the `redirect_back` line with this snippet in PostsController and CommentsController. This will render `app/views/posts/vote.js.erb` for posts and `app/views/comments/vote.js.erb` for comments when the request is sent using Ajax. [(Docs)](https://guides.rubyonrails.org/working_with_javascript_in_rails.html#a-simple-example)
```ruby
@upvote = params[:vote]

respond_to do |format|
  format.html do
    redirect_back fallback_location: root_path
  end
  format.js
end
```

#### Enable usage of jQuery 
Add the following lines to `app/javascript/packs/application.js`:
```
window.jQuery = $;
window.$ = $;
```

#### Modify `vote` partial 
- Set the `:remote` option of `link_to` to `true` to set the `data-remote` attribute of the resulting anchor tag to `true`. JavaScript code that comes with Rails will see this and send the request using Ajax. [(Docs)](https://guides.rubyonrails.org/working_with_javascript_in_rails.html#link-to)
- Wrap the total votes display in a `span` element and dynamically generate ids for the element so we can reference them easily in the DOM.
- Add classes to the `upvote` and `downvote` parts so we can reference them easily in the DOM.

```
# app/views/shared/_vote.html.erb 

<% if obj.class == Post %>
  <% url_true = vote_post_path(obj, vote: true) %>
  <% url_false = vote_post_path(obj, vote: false) %>
<% elsif obj.class == Comment %>
  <% url_true = vote_post_comment_path(obj.post, obj, vote: true) %>
  <% url_false = vote_post_comment_path(obj.post, obj, vote: false) %>
<% end %>

<span class='upvote'>
  <% if !current_user || obj.votes.where(user_id: current_user.id, vote: true).empty? %>
    <%= link_to url_true, method: 'post', remote: true do %>
      <%= fa_icon 'arrow-up' %>
    <% end %>
  <% else %>
    <%= fa_icon 'arrow-up', class: 'disabled' %>
  <% end %>
</span>
<div id='<%= obj.class %>_<%= obj.id %>_votes'><%= obj.total_votes %></div>
<span class='downvote'>
  <% if !current_user || obj.votes.where(user_id: current_user.id, vote: false).empty? %>
    <%= link_to url_false, method: 'post', remote: true do %>
      <%= fa_icon 'arrow-down' %>
    <% end %>
  <% else %>
    <%= fa_icon 'arrow-down', class: 'disabled' %>
  <% end %>
</span>
```

#### Create javascript templates
I don't know how to DRY this up yet.
```
// app/views/posts/vote.js.erb

$total_votes = $('#<%= @post.class %>_<%= @post.id %>_votes');
$total_votes.text(<%= @post.total_votes %>);
$upvote = $total_votes.siblings('.upvote');
$downvote = $total_votes.siblings('.downvote');

if (<%= @upvote %>) {
  $upvote.html('<i><i class="fas fa fa-arrow-up disabled"></i>');
  $downvote.html('<%= link_to(vote_post_path(@post, vote: false), method: 'post', remote: true) {|x| fa_icon 'arrow-down'} %>');
} else {
  $downvote.html('<i><i class="fas fa fa-arrow-down disabled"></i>');
  $upvote.html('<%= link_to(vote_post_path(@post, vote: true), method: 'post', remote: true) {|x| fa_icon 'arrow-up'} %>');
}
```

```
// app/views/comments/vote.js.erb

$total_votes = $('#<%= @comment.class %>_<%= @comment.id %>_votes');
$total_votes.text(<%= @comment.total_votes %>);
$upvote = $total_votes.siblings('.upvote');
$downvote = $total_votes.siblings('.downvote');

if (<%= @upvote %>) {
  $upvote.html('<i><i class="fas fa fa-arrow-up disabled"></i>');
  $downvote.html('<%= link_to(vote_post_comment_path(@comment, vote: false), method: 'post', remote: true) {|x| fa_icon 'arrow-down'} %>');
} else {
  $downvote.html('<i><i class="fas fa fa-arrow-down disabled"></i>');
  $upvote.html('<%= link_to(vote_post_comment_path(@comment, vote: true), method: 'post', remote: true) {|x| fa_icon 'arrow-up'} %>');
}
```

## Lecture 8

