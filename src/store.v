module cache

// Store in an interface for custom cache stores.
// get should retrieve a value from the cache store.
// set should add a key-value pair to the cache store.
// del should remove a key-value pair from the cache store.
// clear should remove all key-value pairs from the cache store that have the given key prefix.
interface Store {
mut:
	get(key string) !string
	set(key string, value string) !
	del(key string) !
	clear(key_prefix string) !
}
