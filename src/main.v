import webview { Webview }
import os

[heap]
struct App {
	window &Webview
mut:
	config Config
	port   int
}

const (
	// Currently we'll encounter a bug when splitting a comptime constant and
	// other constants among files, therefore we'll keep them here for now.
	// E.g. `v -cc gcc -d appimage .` would error, when moving the cfg consts to `config.v`.
	ui_path = $if appimage ? {
		os.getenv('APPDIR') + '/usr/share/ui/build'
	} $else {
		'ui/build'
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
	$if dev ? {
		// `v -d dev run .` aims to connect to an already running `vite dev` server.
		// (Run `npm run dev` in the `ui/` dir in another terminal.)
		//
		// For an automated approach in a node environment, we could create a function, e.g. `serve_dev`,
		// that runs an `os.Process` with `npm run dev` and dynamically determine the port.
		// Check out the `use-serve` branch to see a smiliar approach while using `serve` instead of `vweb`.
		app.port = 5173
	} $else {
		app.serve()
	}
	os.signal_opt(.int, app.handle_interrupt)!
	app.run()
}

fn (mut app App) run() {
	app.load_config() or { panic('Failed loading config. ${err}') }
	app.bind()
	app.window.set_title('Emoji Mart')
	app.window.set_size(352, 435, .@none)
	app.window.navigate('http://localhost:${app.port}')
	app.window.run()
	app.window.destroy()
	app.save_config()
}

fn (mut app App) handle_interrupt(signal os.Signal) {
	app.save_config()
	exit(0)
}
