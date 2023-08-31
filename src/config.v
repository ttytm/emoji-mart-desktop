import os
import toml

struct Config {
mut:
	audio    bool // Last state of audio feedback feedback setting for emoji selections
	frequent bool // Controls whether or not frequently used emojis are shown
	port     int  // Default port the app is tried to be served on.
}

const default_port = 34763

fn (mut app App) load_config() ! {
	if !os.is_dir(cfg_dir) {
		os.mkdir_all(cfg_dir)!
	}
	if !os.is_file(cfg_file) {
		os.write_file(cfg_file, toml.encode(Config{}))!
	}
	user_config := toml.parse_file(cfg_file)!
	port := user_config.value('port').default_to(default_port).int()
	app.config = Config{
		audio: user_config.value('audio').default_to(true).bool()
		frequent: user_config.value('frequent').default_to(true).bool()
		port: if port != 0 { port } else { default_port }
	}
}

fn (mut app App) save_config() {
	os.write_file(cfg_file, toml.encode(app.config)) or { panic('Failed saving config. ${err}') }
}
