import os
import toml

struct Config {
mut:
	audio    bool = true // Last state of audio feedback feedback setting for emoji selections
	frequent bool = true // Controls whether or not frequently used emojis are shown
}

fn (mut config Config) load() {
	if f := toml.parse_file(cfg_file) {
		config = f.decode[Config]() or { return }
	}
}

fn (config Config) save() ! {
	if !os.is_dir(cfg_dir) {
		os.mkdir_all(cfg_dir)!
	}
	os.write_file(cfg_file, toml.encode(config))!
}
