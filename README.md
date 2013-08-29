# CachedAt

[![Build Status](https://api.travis-ci.org/delwyn/cached_at.png?branch=master)](http://travis-ci.org/delwyn/cached_at)
[![Code Climate](https://codeclimate.com/github/delwyn/cached_at.png)](https://codeclimate.com/github/delwyn/cached_at)

Use cached_at for ActiveRecord cache key instead of updated at

## Installation

Add this line to your application's Gemfile:

    gem 'cached_at'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cached_at

## Usage
Too add to any class, just include CachedAt

    class User
      include CachedAt
    end

You will need to add the cached_at column to the table

    rails generate migration add_cached_at_to_users cached_at:datetime

The cache_at column will be update when a record is created or updated.

    user = User.create # sets the cached_at
    user.save          # updates cached_at if another attribute on the record has changed

When a records associations are created/updated, the cached_at column will be updated but the updated_at will not change.

    class Post
      belongs_to :user, touch: true
    end

    post = Post.create user: user # updates the user cached_at

Gem also provides class method `cache_key` for your model, that
 will generate cache key string from `maximum(:cached_at)`

    Post.cache_key
    # SELECT MAX(`posts`.`cached_at`) AS max_id FROM `posts`
    # => "Post-1377768216"

You can use this inside your cachin syntax when you are monitoring if model was changed.

    Rails.cache.fetch [Post, 'last_posts'] do
      Post.last_posts
    end
    # => Cache fetch_hit: Post-1377768216/last_posts


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
