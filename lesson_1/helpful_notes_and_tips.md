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
