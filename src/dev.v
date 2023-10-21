import os
import term

// Running the application with `v -d dev run .` runs an `npm run dev` process
// and connects to the localhost port on which the application is being served on.
[if dev ?]
fn (mut app App) serve_dev() {
	mut npm_path := os.find_abs_path_of_executable('npm') or {
		eprintln('Failed finding node package manager.\nMake sure npm is executable.')
		exit(0)
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
	app.proc = p
	if app.port == 0 {
		eprintln('Failed serving to localhost.')
		app.kill_proc()
		exit(0)
	}
}

[if dev ?]
fn (mut app App) kill_proc() {
	app.proc.signal_pgkill()
}
