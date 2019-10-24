# Instructions
Add actions and views to allow a user to create a new post.

# Flashcards 

### What does the `label` element do?
Screen readers read the text in the label tag to let the user know what text is associated with an input element. This is very useful for the vision-impaired.

Example of how it would be used within a form:
```
<label for="title">Input a title</label>
<input id="title" name="title" type="text">
```
The screen reader would read "Input a title".

It is also a nice usability feature. When you click on the label, the browser focuses on the input.
(Source: Lecture 3 Part 1 Video, -26:00)

### Explain how the form_for method works.
(Source: Lecture 3 Part 1 Video, -21:40)

### Would you ever want to create a pure html form in Rails? Why or why not?
No, because you would have to comment out `protect_from_forgery`.

### What does protect_from_forgery do?

### How can you use mass assignment? How do you work with strong params? 
(Source: Lecture 3 Part 1 Video, -9:40) Explanation of strong params
(Source: Lecture 3 Part 1 Video, -7:50) How to work around 

### What happens when you submit a value in a form for a param that is not permitted? For example, if you only permit title and the user submits title and url?
"Unpermitted parameters: url" is printed in the console. No exception is thrown. This can be a source of silent bugs in your app. But you don't want to tell a hacker that their hacking has failed. You want silently counter their malicious act.
(Source: Lecture 3 Part 1 Video, -5:33)

You can only use attributes or virtual attributes as labels and text field params when using model-backed form helpers.
