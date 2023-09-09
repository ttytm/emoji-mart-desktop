import webview { Event }
import os

fn (mut app App) bind() {
	app.window.bind('get_config', app.get_config) // Bind a function method to have the app struct available.
	app.window.bind('play_audio', app.play_audio)
	app.window.bind_ctx('toggle_audio', toggle_audio, app) // Alternatively, use the ctx ptr to pass a struct.
	app.window.bind('open_in_browser', open_in_browser)
}

// The functions we bind do not have to be public. For semantic reasons or
// if we would want to generate docs for pub functions we can do it anyway.

pub fn (app &App) get_config(e &Event) {
	e.@return(app.config)
}

pub fn (app &App) play_audio(_ &Event) {
	if app.config.audio {
		spawn play_wav_file()
	}
}

pub fn toggle_audio(e &Event, mut app App) {
	app.config.audio = !app.config.audio
	if app.config.audio {
		spawn play_wav_file()
	}
	e.@return(app.config.audio)
}

pub fn open_in_browser(e &Event) {
	os.open_uri(e.string(0)) or {
		eprintln(err)
		return
	}
}
