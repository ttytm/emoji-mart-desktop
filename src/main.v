import webview { Webview }
import os

@[heap]
struct App {
mut:
	window Webview
	config Config
	cache  LocalStorage
	port   int
}

fn main() {
	mut app := App{
		window: webview.create()
	}
	app.config.load()
	app.cache.load()
	os.signal_opt(.int, app.handle_interrupt)!
	app.run()!
}

fn (mut app App) run() ! {
	app.bind()
	app.window.set_title('Emoji Mart')
	app.window.set_size(352, 435, .@none)
	app.window.set_icon(paths.icon) or {} // FIXME: `assets/emoji-mart.ico` not recognized on linux.
	$if dev ? {
		app.window.serve_dev(paths.ui)!
	} $else {
		app.window.serve_static(paths.ui)
	}
	app.window.run()
	app.end()
}

fn (mut app App) end() {
	app.window.destroy()
	app.config.save() or { panic('failed to save config. ${err}') }
	app.cache.save() or { panic('failed to load cache. ${err}') }
}

fn (mut app App) handle_interrupt(signal os.Signal) {
	app.end()
	exit(0)
}
