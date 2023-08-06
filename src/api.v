import os
import json

fn (mut app App) bind() {
	app.window.bind('play_sound', play_sound, &app)
	app.window.bind('toggle_audio', toggle_audio, &app)
	app.window.bind('open_in_browser', open_in_browser, &app)
}

// The functions we bind do not have to be public. For semantic reasons we can do it anyway.

pub fn play_sound(_ &char, _ &char, app &App) {
	if app.settings.sound {
		spawn play_wav_file()
	}
}

pub fn toggle_audio(event_num &char, raw_args &char, mut app App) {
	app.settings.sound = !app.settings.sound
	if app.settings.sound {
		play_sound(event_num, raw_args, app)
	}
	app.window.result(event_num, .value, json.encode(app.settings.sound))
}

pub fn open_in_browser(_ &char, raw_args &char, app &App) {
	link := json.decode([]string, unsafe { raw_args.vstring() }) or { return }[0]
	os.open_uri(link) or {
		eprintln(err)
		return
	}
}
