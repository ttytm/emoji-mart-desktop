import os
import json

pub struct LocalStorage {
mut:
	frequently string
}

fn (mut cache LocalStorage) load() {
	if f := os.read_file(cache_file) {
		cache = json.decode(LocalStorage, f) or { LocalStorage{} }
	}
}

fn (cache LocalStorage) save() ! {
	if !os.is_dir(cache_dir) {
		os.mkdir_all(cache_dir)!
	}
	os.write_file(cache_file, json.encode(cache))!
}
