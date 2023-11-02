import os { join_path }

struct Paths {
mut:
	root       string
	tmp        string
	ui_dev     string
	ui         string
	sound_dev  string
	sound      string
	icon_dev   string
	icon       string
	cfg_dir    string
	cfg_file   string
	cache_dir  string
	cache_file string
}

fn init() {
	mut p := &Paths{}
	unsafe {
		p = paths
	}
	app_root := @VMODROOT
	p.ui_dev = join_path(app_root, 'ui')
	p.sound_dev = join_path(app_root, 'assets', 'pop.wav')
	p.icon_dev = join_path(app_root, 'assets', 'emoji-mart.ico')
	$if prod {
		app_tmp := join_path(os.temp_dir(), '${app_name}-@${version}')
		p.ui = join_path(app_tmp, 'ui')
		p.sound = join_path(app_tmp, 'assets', 'pop.wav')
		p.icon = join_path(app_tmp, 'assets', 'icon.ico')
	} $else {
		p.ui = p.ui_dev
		p.sound = p.sound_dev
		p.icon = p.icon_dev
	}
	// Config
	p.cfg_dir = join_path(os.config_dir() or { panic(err) }, app_name)
	p.cfg_file = join_path(p.cfg_dir, '${app_name}.toml')
	// Cache
	p.cache_dir = join_path(os.cache_dir(), app_name, 'LocalStorage')
	p.cache_file = join_path(p.cache_dir, 'localStorage.json')
}
