# Adding a new ITS user

First of all, for most things ITS will not require a user to be logged in under a name. You can just type ^Z and start working. Some programs do require you to have a user name, and maybe even to have a home directory. However, it is somewhat rude to use ITS anonymously.

To log in and assign a user name, type :LOGIN NAME or NAME$U, where NAME is to be substituted for your user name. Using the winning $U command does have a slight difference: ..CLOBRF and ..MORWARN will be set to 0. Originally, ITS would not ask for a password so there was no protection against logging in as someone else. As more and more Arpanet randoms were seen to hog precious resources, ITS was coerced into adding a password facility.

If you don't have a home directory, DDT will complain. This is harmless, but making your own directory is a good idea. To do that, type ^R NAME; ..NEW. (UDIR). DDT will say “no such file”, but the directory will be created. The NAME directory will now be yours by virtue of having the same name as the user name. This need not be the case for all users though; see below.

Having your own home directory is good enough for almost everything you need, but to really make yourself an official ITS user you should register with the INQUIR user database. To do this, type :INQUIR and answer all questions. Finally end with the DONE command.

When you log in, DDT will check the INQUIR database for the name of your home directory. Using this facility, your home directory can have a name different from your user name.