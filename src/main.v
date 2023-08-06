import webview { Webview }
import os

struct App {
	window &Webview
mut:
	port     int
	proc     os.Process
	settings struct {
	mut:
		sound bool = true
	}
}

const (
	// Currently we'll encounter a bug when splitting these comptime consts among files,
	// therefore we'll keep them here for now.
	ui_path = $if appimage ? {
		os.getenv('APPDIR') + '/usr/share/ui/build'
	} $else {
		'ui/build'
	}
	sound_file_path = $if appimage ? {
		os.getenv('APPDIR') + '/usr/share/assets/pop.wav'
	} $else {
		'assets/pop.wav'
	}
)

fn main() {
	mut app := App{
		window: webview.create(
			debug: $if prod { true } $else { false }
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
	app.run()
	app.window.destroy()
}

fn (mut app App) run() {
	app.bind()
	app.window.set_title('Emoji Mart')
	app.window.set_size(352, 435, .@none)
	app.window.navigate('http://localhost:${app.port}')
	app.window.run()
}
