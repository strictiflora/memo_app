# Memo_app
Memo_app is a simple app to take notes. You can take notes, edit them, and delete them.

# Installation
Clone this repository.
```
% git clone https://github.com/strictiflora/memo_app
```

Change directory to memo_app.
```
% cd memo_app
```

If you use Ruby 3.0.0 or later, you need to uncomment a line: `# gem 'webrick'` in your Gemfile.
```
gem 'webrick'
```

Run `bundle install`.
```
% bundle install
```

# Quickstart
Run the command below to create a table in PostgreSQL.(A database named 'postgres' is needed.)
```
% psql -d postgres -f create_table.sql
```

Just run `bundle exec ruby memo_app.rb` and access `http://localhost:4567`.
```
% bundle exec ruby memo_app.rb
```
