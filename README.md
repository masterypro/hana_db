# HanaDB

Provides plain access to the SAP Hana database.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hana_db'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hana_db

## Usage

```ruby
  require 'hana_db/extensions/idle'    
  
  db = HanaDB.prepare(dsn: 'hana', username: 'username', password: 'password') do |db|
    db.use HanaDB::Extensions::IDLE, 300
  end
  db.select_one('...')
```
