import os

// Example of two static embedded files.
const icon = $embed_file('../assets/emoji-mart.ico')
// Note: Currently, this one must be in a differnt dir, else V embeds the wrong file.
// Else the path would be `../assets/pop.wav`.
const sound = $embed_file('../assets/audio/pop.wav')

fn init() {
	write_embedded() or {
		eprintln('failed to write embedded files: `${err}`')
		exit(1)
	}
}

fn write_embedded() ! {
	if !os.exists(paths.ui) {
		dist_ui_path := os.join_path('dist', 'ui')
		for file in ui {
			_, rel_file_path := file.path.rsplit_once(dist_ui_path) or {
				return error('failed to prepare path for ${file.path}')
			}
			out_path := os.join_path(paths.ui, rel_file_path)
			os.mkdir_all(os.dir(out_path))!
			os.write_file(out_path, file.to_string())!
		}
	}
	if !os.exists(paths.sound) {
		os.mkdir_all(os.dir(paths.sound)) or {}
		os.write_file(paths.sound, sound.to_string())!
	}
	if !os.exists(paths.icon) {
		os.mkdir_all(os.dir(paths.icon)) or {}
		os.write_file(paths.icon, icon.to_string())!
	}
}
