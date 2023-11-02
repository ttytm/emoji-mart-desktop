import os

const (
	sound = $embed_file('../assets/pop.wav')
)

fn write_embedded() ! {
	if !os.exists(paths.ui) {
		for file in ui {
			out_path := file.path.replace(os.join_path(paths.root, 'dist', 'ui'), paths.ui)
			os.mkdir_all(os.dir(out_path))!
			os.write_file(out_path, file.to_string())!
		}
	}
	if !os.exists(paths.sound) {
		path := sound.path.replace('../assets/pop.wav', paths.sound)
		os.mkdir_all(os.dir(path)) or {}
		os.write_file(path, sound.to_string())!
	}
}
