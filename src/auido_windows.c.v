module main

import time
import miniaudio as ma

fn play_wav_file() {
	engine := &ma.Engine{}
	if ma.engine_init(ma.null, engine) != .success {
		panic('failed to initialize audio engine.')
	}
	defer {
		ma.engine_uninit(engine)
	}
	if ma.engine_play_sound(engine, paths.sound.str, ma.null) != .success {
		panic('failed to load and play "${paths.sound}".')
	}
	ma.engine_play_sound(engine, paths.sound.str, ma.null)
	time.sleep(140 * time.millisecond)
}
