# Redis store

The Redis store puts stored cache items in a Redis server.

## Usage

Install with `v install Coachonko.cache`

```V
import coachonko.cache

// Create options structs
mut ro := redis.Options{
  // Refer to Coachonko/redis documentation
}
rso := cache.RedisStoreOptions{
  // Refer to redis_store.v
}

// Create a new RedisStore
store := cache.new_redis_store(rso, mut ro)!

// Use the RedisStore to create or load cache
cat_name := 'Evelina Viktoria Andersson-Holmström'
redis_store.set('cat_name', cat_name)!
cached_cat_name := redis_store.get('cat_name')! // Evelina Viktoria Andersson-Holmström
```
