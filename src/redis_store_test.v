module cache

import time
import coachonko.redis

fn setup_store() &RedisStore {
	rso := RedisStoreOptions{}
	mut ro := redis.Options{}
	store := new_redis_store(rso, mut ro) or { panic(err) }
	return store
}

fn test_new_store() {
	mut store := setup_store()
	assert store.key_prefix == 'cache_'
	assert store.expire == 30 * time.minute
}

fn test_set_and_get() {
	mut store := setup_store()

	if some_unset_value := store.get('some_unset_key') {
		assert false // no value should be returned
		return
	} else {
		if err.msg() == 'nil' {
			assert true
		}
	}

	cat_name := 'Evelina Viktoria Andersson-Holmström'
	store.set('cat_name', cat_name) or { panic(err) }
	cached_cat_name := store.get('cat_name') or {
		assert false
		return
	}
	assert cached_cat_name == 'Evelina Viktoria Andersson-Holmström'
}

fn test_del() {
	mut store := setup_store()
	data := 'test_data'
	store.set('test_key', data) or { panic(err) }
	store.del('test_key') or { panic(err) }
	if cached_data := store.get('test_key') {
		assert false // no value should be returned
		return
	} else {
		if err.msg() == 'nil' {
			assert true
		}
	}
}
