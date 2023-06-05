#README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...


## Lets go!

```
rails server
```




## First time setup

Install rvm

```
brew install gnupg gnupg2
```

Follow instructions to [install rvm](https://rvm.io/rvm/install)

```
echo "source $HOME/.rvm/scripts/rvm" >> ~/.bash_profile
```

```
rvm install 3.2.2
```

```
rvm use 3.2.2 --default
```

```
gem install rails
```


Install postgres

```
brew install postgresql@14
```

```
brew services start postgresql@14
```

Confirm with ```brew services list```


Stop with ```brew services stop postgresql@14```

```
bundle install
```


```
rails db:create
```
