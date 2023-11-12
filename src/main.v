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

fn main() {
	mut app := App{
		window: webview.create()
	}
	app.config.load()
	app.cache.load()
	app.serve()
	os.signal_opt(.int, app.handle_interrupt)!
	app.run()
}

fn (mut app App) run() {
	app.bind()
	app.window.set_title('Emoji Mart')
	app.window.set_icon(paths.icon) or {}
	app.window.set_size(352, 435, .@none)
	app.window.navigate('http://localhost:${app.port}')
	app.window.run()
	app.window.destroy()
	app.end()
}

fn (mut app App) end() {
	app.config.save() or { panic('failed to save config. ${err}') }
	app.cache.save() or { panic('failed to load cache. ${err}') }
	$if dev ? {
		app.proc.signal_pgkill()
	}
}

fn (mut app App) handle_interrupt(signal os.Signal) {
	app.end()
	exit(0)
}
