# cache

cache is a library for managing cache in applications written in the V language. 

The only supported `Store` at the moment is Redis and relies on [patrickpissurno/vredis](https://github.com/patrickpissurno/vredis). This `Store` is developed against [KeyDB](https://github.com/Snapchat/KeyDB).

More stores will be supported by contributions.

## Usage

Install with `v install Coachonko.cache`

```V
import coachonko.cache

// Create a new RedisStore
redis_store := new_redis_store(RedisStoreOptions{})

// Use the RedisStore to create or load cache
cat_name := 'Evelina Viktoria Andersson-Holmström'
redis_store.set('cat_name', cat_name)!
cached_cat_name := redis_store.get('cat_name)! // Evelina Viktoria Andersson-Holmström
```
