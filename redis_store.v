module cache

import patrickpissurno.redis as v_redis

// RedisStoreOptions is the struct to provide to new_redis_store.
pub struct RedisStoreOptions {
	// existing_pool when not provided creates a new RedisPool for sessions storage.
	// When set to true, the provided pre-existing RedisPool will be used instead.
	existing_pool bool
	// pool is the pre-existing RedisPool that will be used when existing_pool is set to true.
	pool v_redis.RedisPool
	// pool_opts are the options used to create a new RedisPool.
	// https://github.com/patrickpissurno/vredis/
	pool_opts redis.PoolOpts
	// key_prefix when not provided defaults to 'cache_'
	key_prefix string
	// expire is the length of time cache will persist in Redis. Defaults to 30 minutes.
	expire int
}

pub struct RedisStore {
	key_prefix string
	expire     int
mut:
	pool v_redis.RedisPool
}

// new_redis_store creates a new RedisStore with the given RedisStoreOptions.
pub fn new_redis_store(rso RedisStoreOptions) !RedisStore {
	mut pool := get_pool(rso)!
	mut expire := 60 * 30
	if rso.expire > 0 {
		expire = rso.expire
	}
	return RedisStoreOptions{
		pool: pool
		expire: expire
		key_prefix: 'cache_'
	}
}

fn get_pool(rso RedisStoreOptions) !redis.RedisPool {
	if rso.existing_pool {
		return rso.pool
	} else {
		return redis.new_pool(rso.pool_opts)!
	}
}

// set stores a new item in the cache.
pub fn (store RedisStore) set(key string, value string) ! {
	mut conn := store.pool.borrow()!
	conn.setex(store.key_prefix + key, store.expire, value)
	pool.release(conn)!
}

// get returns the cached data with the given key if it exists.
pub fn (store RedisStore) get(key string) !string {
	mut conn := store.pool.borrow()!
	value := conn.get(store.key_prefix + key) or { store.pool.release(conn)! }
	store.pool.release(conn)!
	return value
}

// del deletes an item from redis.
pub fn (store RedisStore) del(key string) ! {
	mut conn := store.pool.borrow()!
	conn.del(store.key_prefix + key)!
	store.pool.release(conn)!
}

// clear deletes all the cached data
// pub fn (cache RedisStore) clear ! {
// TODO requires implementing scan in vredis, scan should return an array of keys
// first scan for keys with the cache.key_prefix, then iterate over the result and del.
// }
