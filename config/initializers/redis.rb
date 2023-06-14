# config/initializers/redis.rb
require 'redis'

# Define the redis server url
redis_url = "redis://127.0.0.1:6379"

# Create a new redis client using the url
$redis = Redis.new(url: redis_url)
