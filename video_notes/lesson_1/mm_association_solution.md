Main Idea:  How to support a many to many association using `has_many: through`

- -18:46: ERD Diagram
- -17:55: `rails generate migration create_categories`
- -16:50: create category model
- -16:30: checking in rails console that the category table was created and "linked up" correctly to a model: when we see that rails inferred columns correctly
- -15:58: example of checking in rails console for nonexistent table, even though model file exists
- -15:10: `"PostCategory".tableize`
- -14:28: `rails generate migration post_categories`
- -13:07: set up 1:M association between Post and PostCategory
- -9:40: checking the 1:M association between Post and PostCategory in rails console
- -7:42: set up category model
- -6:22: checking the 1:M association between Category and PostCategory in rails console
- -4:45: set up `has_many: through` associations between post and category, through post_categories
- -4:15: checking the M:M assocations in rails console
