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

const (
	app_name = 'emoji-mart'
	paths    = &Paths{}
)

fn init() {
	mut p := &Paths{}
	unsafe {
		p = paths
	}
	$if embed ? {
		tmp_dir := join_path(os.temp_dir(), '${app_name}-@${version}')
		p.ui = join_path(tmp_dir, 'ui')
		p.sound = join_path(tmp_dir, 'assets', 'pop.wav')
		p.icon = join_path(tmp_dir, 'assets', 'icon.ico')
		write_embedded() or { eprintln('Failed writing embedded files: `${err}`') }
	} $else {
		app_root := @VMODROOT
		p.ui = join_path(app_root, 'ui')
		p.sound = join_path(app_root, 'assets', 'pop.wav')
		p.icon = join_path(app_root, 'assets', 'emoji-mart.ico')
	}
	// Config
	p.cfg_dir = join_path(os.config_dir() or { panic(err) }, app_name)
	p.cfg_file = join_path(p.cfg_dir, '${app_name}.toml')
	// Cache
	p.cache_dir = join_path(os.cache_dir(), app_name, 'LocalStorage')
	p.cache_file = join_path(p.cache_dir, 'localStorage.json')
}
