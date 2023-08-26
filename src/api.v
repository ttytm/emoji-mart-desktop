import webview { EventId, JSArgs }
import os

fn (mut app App) bind() {
	app.window.bind('get_config', get_config, &app)
	app.window.bind('play_audio', play_audio, &app)
	app.window.bind('toggle_audio', toggle_audio, &app)
	app.window.bind('open_in_browser', open_in_browser, &app)
}

// The functions we bind do not have to be public. For semantic reasons we can do it anyway.

pub fn get_config(event_id EventId, _ JSArgs, app &App) {
	app.window.@return(event_id, .value, app.config)
}

pub fn play_audio(_ EventId, _ JSArgs, app &App) {
	if app.config.audio {
		spawn play_wav_file()
	}
}

pub fn toggle_audio(event_id EventId, args JSArgs, mut app App) {
	app.config.audio = !app.config.audio
	if app.config.audio {
		play_audio(event_id, args, app)
	}
	app.window.@return(event_id, .value, app.config.audio)
}

pub fn open_in_browser(_ EventId, args JSArgs, app &App) {
	os.open_uri(args.string(0)) or {
		eprintln(err)
		return
	}
}
