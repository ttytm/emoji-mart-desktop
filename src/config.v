import os
import toml

struct Config {
mut:
	audio    bool = true // Last state of audio feedback feedback setting for emoji selections
	frequent bool = true // Controls whether or not frequently used emojis are shown
}

fn (mut config Config) load() {
	if f := toml.parse_file(paths.cfg_file) {
		config = f.decode[Config]() or { return }
	}
}

fn (config Config) save() ! {
	if !os.is_dir(paths.cfg_dir) {
		os.mkdir_all(paths.cfg_dir)!
	}
	os.write_file(paths.cfg_file, toml.encode(config))!
}
