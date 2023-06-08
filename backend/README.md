# Rails Backend API

Ruby version 3.2.2

Built on mac m2 chip, but deployable to x86-linux on Render.

## Lets go!

```
rails db:migrate
```

```
rails server
```

### Development

```
rails db:seed
```

Debugger?  Type ```debugger``` in code to set breakpoint locally.


Tests

```
rspec spec
```

Get Client keys in rails c

```shell
Doorkeeper::Application.find_by(name: "iOS Client").secret
Doorkeeper::Application.find_by(name: "iOS Client").uid
```


### Database

View column attributes of a model from ```rails c```

```
User.columns_hash
```

View all tables

```shell
ActiveRecord::Base.connection.tables
```

Migrate

```shell
rails db:migrate
```

```shell
rails db:rollback
```

View status of applied migrations

```shell
sllewely@Sarahs-Air backend % rails db:migrate:status

database: backend_development

 Status   Migration ID    Migration Name
--------------------------------------------------
   up     20230605194951  Create tests
   up     20230606130646  Devise create users
   up     20230606134035  Create doorkeeper tables
   up     20230606151105  Add namesto users
```

Nuke it

```shell
rails db:drop db:create db:migrate
```

## Graphql

[http://localhost:3000/graphiql](http://localhost:3000/graphiql)

New type

```shell
rails g graphql:object user
```


## Check it out on Render

[api/v1/tests](https://recommendations-backend-h7dq.onrender.com/api/v1/tests)


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
