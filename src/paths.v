import os { join_path }

struct Paths {
mut:
	root       string
	ui         string
	sound      string
	icon       string
	cfg_dir    string
	cfg_file   string
	cache_dir  string
	cache_file string
}

const app_name = 'emoji-mart'
const paths = get_paths()!

fn get_paths() !Paths {
	mut p := Paths{}
	$if embed ? {
		tmp_dir := join_path(os.temp_dir(), '${app_name}-@${version}')
		p.ui = join_path(tmp_dir, 'ui')
		p.sound = join_path(tmp_dir, 'assets', 'pop.wav')
		p.icon = join_path(tmp_dir, 'assets', 'icon.ico')
	} $else {
		app_root := @VMODROOT
		p.ui = join_path(app_root, 'ui', 'build')
		p.sound = join_path(app_root, 'assets', 'audio', 'pop.wav')
		p.icon = join_path(app_root, 'assets', 'emoji-mart.ico')
	}
	// Config
	p.cfg_dir = join_path(os.config_dir()!, app_name)
	p.cfg_file = join_path(p.cfg_dir, '${app_name}.toml')
	// Cache
	p.cache_dir = join_path(os.cache_dir(), app_name, 'LocalStorage')
	p.cache_file = join_path(p.cache_dir, 'localStorage.json')
	return p
}
