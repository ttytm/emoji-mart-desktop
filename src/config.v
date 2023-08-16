import os
import toml

struct Config {
mut:
	audio bool
}

const (
	cfg_dir  = os.config_dir() or { panic(err) } + '/emoji-mart'
	cfg_file = cfg_dir + '/emoji-mart.toml'
)

fn (mut app App) load_config() ! {
	if !os.is_dir(cfg_dir) {
		os.mkdir_all(cfg_dir)!
	}
	if !os.is_file(cfg_file) {
		os.write_file(cfg_file, toml.encode(Config{}))!
	}
	user_config := toml.parse_file(cfg_file)!
	app.config = Config{
		audio: user_config.value('audio').default_to(true).bool()
	}
}

fn (mut app App) save_config() {
	os.write_file(cfg_file, toml.encode(app.config)) or { panic('Failed saving config. ${err}') }
}
