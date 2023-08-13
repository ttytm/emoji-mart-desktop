import os
import json

fn (mut app App) bind() {
	app.window.bind('get_config', get_config, &app)
	app.window.bind('toggle_audio', toggle_audio, &app)
	app.window.bind('open_in_browser', open_in_browser, &app)
}

// The functions we bind do not have to be public. For semantic reasons we can do it anyway.

pub fn get_config(event_id &char, _ &char, app &App) {
	app.window.result(event_id, .value, json.encode(app.config))
}

pub fn toggle_audio(event_id &char, args &char, mut app App) {
	app.config.audio = !app.config.audio
	app.window.result(event_id, .value, json.encode(app.config.audio))
}

pub fn open_in_browser(_ &char, args &char, app &App) {
	link := json.decode([]string, unsafe { args.vstring() }) or { return }[0]
	os.open_uri(link) or {
		eprintln(err)
		return
	}
}
