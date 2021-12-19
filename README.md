# Ibrain::Core
This is core plugin for rails api project

## Usage
Please remove puma gem from your project before add this gem

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'ibrain-core'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install ibrain-core
```

Please install plugin after install this gem
```bash
$ bundle exec rails generate ibrain:install
```
# Migration
Default migration engine is [ridgepole](https://github.com/ridgepole/ridgepole), using this command line to migrate database:
```bash
bundle exec rails ridgpole:apply
```
To use default migration plugin, please disable ridgepole
```bash
bundle exec rails generate ibrain::install --with-ridgepole=false
```
# GraphQL API
If you use graphql for rails please add this option when install plugin
```bash
$ bundle exec rails generate ibrain::install --with-graphql
```
To generate graphql type
```bash
bundle exec rails generate ibrain:graphql:object user
```
To generate graphql resolver single query to get user data
```bash
bundle exec rails generate ibrain:graphql:resolver user --model=User
```
To generate graphql resolvers query to get users list
```bash
bundle exec rails generate ibrain:graphql:resolvers users --model=User
```
For pagination please using aggregate body query, something like
```
query users($offset: Int, $limit: Int, $filter: Filter) {
    users(offset: $offset, limit: $limit, filter: $filter) {
        id
        first_name
    }

    users_aggregate(filter: $filter) {
        total_count
    }
}
```
To generate graphql mutation to insert, update, delete user
```bash
bundle exec rails generate ibrain:graphql:mutation insert_user --model=User
```
## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
