module cache

fn redis_setup() !Store {
	rso := RedisStoreOptions{}
	store := new_redis_store(rso)!
	return store
}

fn test_set_and_get() ! {
	mut redis_store := redis_setup()!
	redis_store.set('test', 'test_value')!
	cached_value := redis_store.get('test')!
	assert cached_value == 'test_value'
}
