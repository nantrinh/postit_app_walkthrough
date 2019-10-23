# The Active Record way says to keep intelligence out of the databases. [link](https://guides.rubyonrails.org/active_record_migrations.html#active-record-and-referential-integrity). Is it best practice to do this?

Chris:
No, but Railsy companies would be ok with this.

Usually, the more important the datastore is, the more rules will be enforced at that layer. You can’t assume it’s just 1 app connecting w/ the db.

If there’s a perfect match between app-level concerns with the db-level concerns and you only expect 1 app to interact w/ the db, then that’s ok. Rails sort of expects this, so for most Rails apps, it’s an ok way to do things.

But in practice, you should add **some** db constraints to enforce the most basic of data integrity levels that you’d expect for your data.

While building the app in 5301, I’d just go with the app-level only constraints so you don’t run into runtime errors interacting w/ the db.

If I saw a db in the wild with no data integrity rules, it’d be a red flag. Or I’d assume it’s very low priority data.

Ian:
I added foreign key constraints throughout that course because I couldn’t handle leaving them out. You can add this to your migrations, and Rails also supports specifying the delete cascade in your models (which is a good idea if you’re enforcing foreign keys at the dB level)

https://guides.rubyonrails.org/active_record_migrations.html#foreign-keys

# I encounter a SQLite3 exception "Cannot add a NOT NULL column with default value NULL" when I try to run a migration that adds a new column with a foreign key constraint to an existing table. The existing table does not have any rows in it. Why am I getting this error?

Answer from StackOverflow: https://stackoverflow.com/a/6710280

This is poor design choice of SQLite. When creating a new table, you can specify NOT NULL, but you cannot do this when adding a column. A workaround is to do the following:
```
  def change
    add_column :posts, :user_id, :integer
    add_foreign_key :posts, :users
  end
```

# What is the difference between `add_foreign_key` and `add_reference` in Rails?

Answer from StackOverflow: https://stackoverflow.com/a/52915296

`add_foreign_key`: adds a new foreign key. `from_table` is the table with the key column, `to_table` contains the referenced primary key.

`add_reference`: a shortcut for creating a column, index and foreign key at the same time.

Foreign keys enforce the relationships between tables. For instance, if you have a `user_id` in a table `posts` that refers to the table `users`, you cannot had a value in `user_id` that does not exist as the primary key in `users`.

# TODO: Should I enforce delete cascade at the model level and at the database level? What are the pros and cons of each approach?
https://stackoverflow.com/questions/12556614/rails-delete-cascade-vs-dependent-destroy/31104268

`has_many :orders, dependent: :destroy`
- Safest option for automatically maintaining data integrity.
- You have polymorphic associations, and do not want to use triggers.

`add_foreign_key :orders, :users, on_delete: :cascade` (in database migration)
- You are not using any polymorphic associations or you want to use triggers for each polymorphic association.

`has_many :orders, dependent: :delete_all`
- Only use when the has_many is a leaf node on your association tree (i.e. the child does not have another has_many association with foreign key references)
