# Lesson 3
## Lecture 5 
### Part 1
- 53:00: review quiz 2
- 41:10: asset pipeline is a way to obfuscate and compress static assets when we deploy our application to production.
- 38:30: what is obfuscation and why use it
- 35:30: how to obfuscation works
- 34:30: cache buster
- 33:40: the problem with caching aggressively
- 31:40: manifest file
- 31:30: sprockets
- 28:42: scss file 
- 19:40: precompiling makes deployment faster but could be the source of bugs
- 19:00: why use has_secure_password instead of a gem
- 18:00: devise comes with the kitchen sink
- 15:36: how passwords are saved; digression
- 14:25: how passwords should be saved; an application should not know what your password is
- 14:00: one-way hash
- 12:20: password digest migration
- 11:00: dictionary attacks
- 9:40: bcrypt-ruby
- 3:34: there is no getter for the password
- 2:50: authenticate method

### Part 2
- 48:05: added actions to users controller
- 42:35: update user model
- 37:30: update routes
- 36:00: sessions controller
- 34:00: sessions new view
- 32:40: sessions create action
- 24:50: save the user id, NOT the user object because cookies have a 4KB size limit. As the user performs more actions, the user object will grow and you may get an overflow error.
- 22:35: sessions create and destroy actions defined
- 22:00: edit navigation partial
- 19:35: expose `:current_user` and `:logged_in?` as helper methods in application controller 
- 18:15: define `current_user` method in application controller
- 12:00: make `current_user` method more performant; hit the database once for each request
- 9:30: control who can do which actions
- 6:30: set user id to authenticated user in the controllers
- 5:00: recap
