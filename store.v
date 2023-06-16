module cache

interface Store {
	get(key string) !
	set(key string, value string) !
	del(key string) !
	// clear()
}
