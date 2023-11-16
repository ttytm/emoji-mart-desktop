module main

import os

fn play_wav_file() {
	$if linux {
		os.system('aplay -q "${paths.sound}"')
	} $else $if macos {
		os.system('afplay -q "${paths.sound}"')
	}
}
