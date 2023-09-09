import os
import toml

struct Config {
mut:
	audio    bool = true // Last state of audio feedback feedback setting for emoji selections
	frequent bool = true // Controls whether or not frequently used emojis are shown
	port     int  = 34763 // Default port the app is tried to be served on.
}

fn (mut config Config) load() ! {
	if !os.is_dir(cfg_dir) {
		os.mkdir_all(cfg_dir)!
	}
	if !os.is_file(cfg_file) {
		os.write_file(cfg_file, toml.encode(Config{}))!
	}
	user_config := toml.parse_file(cfg_file)!
	config = Config{
		audio: user_config.value('audio').bool()
		frequent: user_config.value('frequent').bool()
		port: user_config.value('port').int()
	}
}

fn (config Config) save() {
	os.write_file(cfg_file, toml.encode(config)) or { panic('Failed saving config. ${err}') }
}
