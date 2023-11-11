import os

const (
	// Example of two static embedded files.
	icon  = $embed_file('../assets/emoji-mart.ico')
	// Note: Currently, this one must be in a differnt dir, else V embeds the wrong file.
	// Else the path would be `../assets/pop.wav`.
	sound = $embed_file('../assets/audio/pop.wav')
)

fn write_embedded() ! {
	if !os.exists(paths.ui) {
		dist_ui_path := os.join_path('dist', 'ui')
		for file in ui {
			_, mut out_path := file.path.rsplit_once(dist_ui_path) or {
				return error('failed to prepare path for ${file.path}')
			}
			out_path = os.join_path(paths.ui, out_path)
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
