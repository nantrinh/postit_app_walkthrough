
bcrypt hashes a password x to unique gibberish x' (password_digest).
to check whether a password y is the same as the password set by the user, use bcrypt to hash y to unique gibberish y' and check whether y' == x'.

a salt is a unique chunk of data added to your password before it is hashed. it prevents against rainbow hacks: when hackers run lists of possible passwords through the same algorithm, store the results in a big database, and look up passwords by their hash. with the salt added, hackers would need gigantic databases for each unique salt, so it makes the passwords harder to hack, especially since bcrypt is designed to be computationally expensive.


