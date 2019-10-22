# How I Memorized Rails Routes

We are asked to memorize the 7 default routes created when we define a single entry in the routing file, for example `resources :posts`.

This is how I memorized the 7 routes and the 4 helpers in the [Rails guides](https://guides.rubyonrails.org/v6.0/routing.html#crud-verbs-and-actions): 

![Rails routes and helpers](https://github.com/nantrinh/ls_rails_notes/blob/master/images/rails_routes_and_helpers.jpg)

I used `posts` as an example of a resource and reorganized the table shown in the [guide](https://guides.rubyonrails.org/v6.0/routing.html#crud-verbs-and-actions) in a way that makes sense to me.

There are 4 paths, 4 helpers, and 7 routes. I know the verbs (methods) under each path must be unique, i.e., there can't be two GET requests to /posts that route to two different actions. I fill in the verbs first, then their associated actions.

Finally, I write down the order in which the actions appear, by convention, in the controller file.
