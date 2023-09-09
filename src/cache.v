import os
import json

pub struct LocalStorage {
mut:
	frequently string
}

fn (mut cache LocalStorage) load() ! {
	if !os.is_dir(cache_dir) {
		os.mkdir_all(cache_dir)!
	}
	if !os.is_file(cache_file) {
		os.write_file(cache_file, json.encode(LocalStorage{}))!
	}
	cache = json.decode(LocalStorage, os.read_file(cache_file)!) or { LocalStorage{} }
}

fn (cache LocalStorage) save() {
	os.write_file(cache_file, json.encode(cache)) or { panic('Failed saving cache. ${err}') }
}
