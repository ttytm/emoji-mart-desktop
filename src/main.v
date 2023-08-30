import webview { Webview }
import os

[heap]
struct App {
	window &Webview
mut:
	config   Config
	port     int
	dev_proc DevProc
}

// Processes we create to dynamically run the node environment in a development context
struct DevProc {
mut:
	main      os.Process
	node_pids []string
}

const (
	// Currently we'll encounter a bug when splitting a comptime constant and
	// other constants among files, therefore we'll keep them here for now.
	// E.g. `v -cc gcc -d appimage .` would error, when moving the cfg consts to `config.v`.
	ui_path = $if appimage ? {
		os.getenv('APPDIR') + '/usr/share/ui'
	} $else {
		'ui'
	}
	sound_file_path = $if appimage ? {
		os.getenv('APPDIR') + '/usr/share/assets/pop.wav'
	} $else {
		'assets/pop.wav'
	}
	cfg_dir  = os.config_dir() or { panic(err) } + '/emoji-mart'
	cfg_file = cfg_dir + '/emoji-mart.toml'
)

fn main() {
	mut app := App{
		window: webview.create(
			debug: $if prod { false } $else { true }
		)
	}
	app.load_config() or { panic('Failed loading config. ${err}') }
	$if dev ? {
		app.serve_dev()
	} $else {
		app.serve()
	}
	os.signal_opt(.int, app.handle_interrupt)!
	app.run()
}

fn (mut app App) run() {
	app.bind()
	app.window.set_title('Emoji Mart')
	app.window.set_size(352, 435, .@none)
	app.window.navigate('http://localhost:${app.port}')
	app.window.run()
	app.window.destroy()
	app.save_config()
	app.kill_dev_proc()
}

fn (mut app App) handle_interrupt(signal os.Signal) {
	app.save_config()
	app.kill_dev_proc()
	exit(0)
}
