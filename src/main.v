import webview { Webview }
import os

[heap]
struct App {
	window &Webview
mut:
	config Config
	cache  LocalStorage
	port   int
	proc   os.Process // OS process spawned when running the app with `v -d dev`
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
	cfg_dir    = os.join_path(os.config_dir() or { panic(err) }, 'emoji-mart')
	cfg_file   = os.join_path(cfg_dir, 'emoji-mart.toml')
	cache_dir  = os.join_path(os.cache_dir(), 'emoji-mart', 'LocalStorage')
	cache_file = os.join_path(cache_dir, 'localStorage.json')
)

fn main() {
	mut app := App{
		window: webview.create(
			debug: $if prod { false } $else { true }
		)
	}
	app.config.load() or { panic('Failed loading config. ${err}') }
	app.cache.load() or { panic('Failed loading cache. ${err}') }
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
	app.config.save()
	app.cache.save()
	app.kill_proc()
}

fn (mut app App) handle_interrupt(signal os.Signal) {
	app.config.save()
	app.cache.save()
	app.kill_proc()
	exit(0)
}
