import os

// Running the application with `v -d dev run .` runs an `npm run dev` process
// and connects to the localhost port on which the application is being served on.
[if dev ?]
fn (mut app App) serve_dev() {
	which_npm := os.execute('which npm')
	if which_npm.exit_code != 0 {
		eprintln('Failed finding `npm`. Make sure `npm` is executable.')
		exit(0)
	}
	mut p := os.new_process(which_npm.output.trim_space())
	p.set_args(['run', 'dev'])
	p.set_work_folder(ui_path)
	p.set_redirect_stdio()
	p.run()
	for p.is_alive() {
		// stdout_read() ~= `INFO  Accepting connections at http://localhost:3000`
		line := p.stdout_read()
		if line.contains('localhost:') {
			app.port = line.all_after_last(':').trim_space().int()
			break
		}
	}
	app.dev_proc.main = p
	// The pids for a node process that is started by `npm run <script>` differ from the `app.dev_proc.main.pid`
	serve_pids := os.execute('pgrep -f "ui/node_modules/.bin/vite dev"')
	app.dev_proc.node_pids = if serve_pids.exit_code == 0 {
		serve_pids.output.split_into_lines()
	} else {
		[]string{}
	}
	if app.port == 0 {
		eprintln('Failed serving to localhost.')
		app.kill_dev_proc()
		exit(0)
	}
}

[if dev ?]
fn (mut app App) kill_dev_proc() {
	app.dev_proc.main.signal_kill()
	if app.dev_proc.node_pids.len > 0 {
		for id in app.dev_proc.node_pids {
			os.execute('kill ${id}')
		}
	}
}
