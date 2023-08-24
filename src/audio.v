module main

import time
import miniaudio as ma

fn play_wav_file() {
	engine := &ma.Engine{}
	result := ma.engine_init(ma.null, engine)
	if result != .success {
		panic('Failed to initialize audio engine.')
	}
	defer {
		ma.engine_uninit(engine)
	}
	if ma.engine_play_sound(engine, sound_file_path.str, ma.null) != .success {
		panic('Failed to load and play "${sound_file_path}".')
	}
	ma.engine_play_sound(engine, sound_file_path.str, ma.null)
	time.sleep(140 * time.millisecond)
}
