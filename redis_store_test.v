module cache

import x.json2 as json

struct TestStruct {
	id   int
	name string
	data map[string]json.Any
}

fn new_test_struct() TestStruct {
	mut data_map := map[string]json.Any{}
	data_map['name'] = 'data_map_name'
	data_map['id'] = 9
	mut arr := []json.Any{}
	arr << 'coachonko'
	arr << 'gastrocnemius'
	arr << json.null
	arr << 12
	data_map['arr_key'] = arr

	return TestStruct{
		id: 9
		name: 'test struct name'
		data: data_map
	}
}

fn redis_setup() !Store {
	rso := RedisStoreOptions{}
	store := new_redis_store(rso)!
	return store
}

fn test_set_and_get_simple() ! {
	mut redis_store := redis_setup()!

	cat_name := 'Evelina Viktoria Andersson-Holmström'
	redis_store.set('cat_name', cat_name)!
	cached_cat_name := redis_store.get('cat_name')!
	assert cached_cat_name == 'Evelina Viktoria Andersson-Holmström'
}

// Broken https://github.com/patrickpissurno/vredis/issues/25
// fn test_set_and_get_objects() ! {
// 	mut redis_store := redis_setup()!

// big_object := json.encode(new_test_struct())
// println(big_object)
// redis_store.set('big_object', big_object)!
// cached_big_object := redis_store.get('big_object')!
// println(cached_big_object)
// assert cached_big_object == big_object
// }
