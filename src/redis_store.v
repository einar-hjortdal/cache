module cache

import time
import coachonko.redis

// RedisStoreOptions is the struct to provide to new_redis_store.
pub struct RedisStoreOptions {
	// key_prefix when not provided defaults to 'cache_'
	key_prefix string
	// expire is the length of time cache will persist in Redis. Defaults to 30 minutes.
	expire time.Duration
}

pub struct RedisStore {
	RedisStoreOptions
mut:
	client redis.Client
}

// new_redis_store creates a new RedisStore with the given RedisStoreOptions.
pub fn new_redis_store(rso RedisStoreOptions, mut ro redis.Options) !&RedisStore {
	mut new_expire := rso.expire
	if new_expire <= 0 {
		new_expire = 30 * time.minute
	}
	mut new_key_prefix := rso.key_prefix
	if new_key_prefix == '' {
		new_key_prefix = 'cache_'
	}
	return &RedisStore{
		RedisStoreOptions: RedisStoreOptions{
			expire: new_expire
			key_prefix: new_key_prefix
		}
		client: redis.new_client(mut ro)
	}
}

/*
*
*
* Store interface
*
*
*/

pub fn (mut store RedisStore) set(key string, value string) ! {
	store.client.set('${store.key_prefix}${key}', value, store.expire)!
}

// get returns the cached data with the given key if it exists.
pub fn (mut store RedisStore) get(key string) !string {
	get_res := store.client.get('${store.key_prefix}${key}')!
	if get_res.err() == 'nil' {
		return error('nil')
	}
	return get_res.val()
}

// del deletes an item from redis.
pub fn (mut store RedisStore) del(key string) ! {
	store.client.del('${store.key_prefix}${key}')!
}

// clear deletes all the cached data
pub fn (mut store RedisStore) clear(key_prefix string) ! {
	// TODO requires implementing scan in coachonko.redis, scan should return an array of keys.
	// First scan for keys with the cache.key_prefix, then iterate over the result with del.
	return error('Method not implemented yet.')
}
