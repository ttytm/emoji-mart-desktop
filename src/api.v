import webview { Event }
import os

fn (mut app App) bind() {
	// Bind a function.
	app.window.bind('open_in_browser', open_in_browser)
	// Bind a function method to make the app struct available.
	app.window.bind('get_config', app.get_config)
	app.window.bind('get_cache', app.get_cache)
	app.window.bind('handle_select', app.handle_select)
	// Alternatively, use `bind_ctx` and use the context pointer to pass a struct.
	app.window.bind_ctx('toggle_audio', toggle_audio, app)
}

// The functions we bind do not have to be public. For semantic reasons or
// if we would want to generate docs for pub functions we can do it anyway.

pub fn (app &App) get_config(_ &Event) Config {
	return app.config
}

pub fn (mut app App) handle_select(e &Event) voidptr {
	if app.config.audio {
		spawn play_wav_file()
	}
	app.cache.frequently = e.string(0)
	return webview.no_result
}

pub fn toggle_audio(e &Event, mut app App) bool {
	app.config.audio = !app.config.audio
	if app.config.audio {
		spawn play_wav_file()
	}
	return app.config.audio
}

pub fn (app &App) get_cache(e &Event) string {
	return app.cache.frequently
}

pub fn open_in_browser(e &Event) voidptr {
	os.open_uri(e.string(0)) or {
		eprintln(err)
		return webview.no_result
	}
	return webview.no_result
}
