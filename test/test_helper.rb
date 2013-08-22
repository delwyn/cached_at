require 'bundler/setup'
require 'cached_at'
require 'minitest/autorun'
require 'active_record'

class Minitest::Spec
  class << self
    alias :context :describe
  end
end

ActiveRecord::Base::establish_connection(adapter: 'sqlite3', database: ':memory:')

ActiveRecord::Base.connection.execute(%{CREATE TABLE users  (id INTEGER PRIMARY KEY, name VARCHAR, updated_at DATETIME, cached_at DATETIME);})
ActiveRecord::Base.connection.execute(%{CREATE TABLE posts  (id INTEGER PRIMARY KEY, title STRING, user_id INTEGER, updated_at DATETIME);})

class User < ActiveRecord::Base
  include CachedAt
end

class Post < ActiveRecord::Base
  belongs_to :user, touch: true
end
