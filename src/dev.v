import os
import term

// Running the application with `v -d dev run .` runs an `npm run dev` process
// and connects to the localhost port on which the application is being served on.
[if dev ?]
fn (mut app App) serve_dev() {
	npm_path_error := fn () {
		eprintln('Failed finding node package manager.\nMake sure npm is executable.')
		exit(0)
	}
	mut npm_path := ''
	$if windows {
		paths := os.execute('where npm')
		if paths.exit_code != 0 {
			npm_path_error()
		}
		for p in paths.output.trim_space().split_into_lines() {
			if p.contains('npm.cmd') {
				npm_path = p
			}
		}
	} $else {
		path := os.execute('which npm')
		if path.exit_code != 0 {
			npm_path_error()
		}
		npm_path = path.output.trim_space()
	}
	if npm_path == '' {
		npm_path_error()
	}
	mut p := os.new_process(npm_path)
	p.use_pgroup = true
	p.set_args(['run', 'dev'])
	p.set_work_folder(ui_path)
	p.set_redirect_stdio()
	p.run()
	for p.is_alive() {
		line := p.stdout_read()
		if line.contains('localhost:') {
			app.port = term.strip_ansi(line.all_after('localhost:').trim_space()).int()
			break
		}
	}
	app.dev_proc.main = p
	if app.port == 0 {
		eprintln('Failed serving to localhost.')
		app.kill_dev_proc()
		exit(0)
	}
}

[if dev ?]
fn (mut app App) kill_dev_proc() {
	app.dev_proc.main.signal_pgkill()
}
