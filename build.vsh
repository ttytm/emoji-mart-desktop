#!/usr/bin/env -S v

import cli
import os

[params]
struct BuildParams {
	mode     BuildMode [required]
	appimage bool
}

enum BuildMode {
	release
	dev
}

fn which(cmd string) ?string {
	path := execute('which ${cmd}').output.trim_space()
	if path == '' {
		return none
	}
	return path
}

fn exec(proc_path string, work_folder string, args []string) {
	mut p := new_process(proc_path)
	p.set_work_folder(work_folder)
	p.set_args(args)
	p.wait()
}

fn build_ui() ! {
	npm_path := if path := which('npm') {
		path
	} else {
		eprintln('Failed finding node package manager.\nMake sure npm is executable.')
		exit(0)
	}

	// Install node modules
	exec(npm_path, '${@VMODROOT}/ui', ['install'])
	// Build static web app
	exec(npm_path, '${@VMODROOT}/ui', ['run', 'build'])

	// Remove `dist/` if it exits - ignore errors if it doesn't
	rmdir_all('dist') or {}
	// Create `dist/` - fail is next to impossible as `dist/` does not exist at this point
	mkdir_all('dist/ui')!
	// Copy UI files to dist
	cp_all('ui/build/', 'dist/ui/build', false)!
}

fn build_bin(flags string) {
	build_cmd := 'v -cc clang ${flags} -o ${@VMODROOT}/dist/emoji-mart ${@VMODROOT}/'
	println('Building binary: ${build_cmd}')
	res := execute(build_cmd)
	if res.exit_code != 0 {
		eprintln(res.output)
		exit(1)
	}
}

fn build(cmd cli.Command) ! {
	build_ui()!
	mut flags := if cmd.name == 'dev' { '' } else { '-prod' }
	if cmd.flags[0].get_bool()! {
		flags += ' -d appimage'
		defer {
			build_appimage() or {
				eprintln('Failed building appimage. ${err}')
				exit(0)
			}
		}
	}
	build_bin(flags)
}

fn build_appimage() ! {
	println('Building appimage')
	mkdir_all('dist/appimage/AppDir/usr/bin')!
	mkdir_all('dist/appimage/AppDir/usr/share/icons')!
	mkdir('dist/appimage/AppDir/usr/share/assets')!
	cp_all('dist/ui/', 'dist/appimage/AppDir/usr/share/ui/', false)!
	cp_all('dist/emoji-mart', 'dist/appimage/AppDir/usr/bin/', false)!
	cp('assets/AppImageBuilder.yml', 'dist/appimage/AppImageBuilder.yml')!
	cp('assets/emoji-mart.png', 'dist/appimage/AppDir/usr/share/icons/emoji-mart.png')!
	cp('assets/pop.wav', 'dist/appimage/AppDir/usr/share/assets/pop.wav')!
	exec(which('appimage-builder') or { panic('Failed finding appimage-builder.') }, '${@VMODROOT}/dist/appimage',
		['--recipe', 'AppImageBuilder.yml', '--skip-tests'])
}

mut cmd := cli.Command{
	name: 'build.vsh'
	posix_mode: true
	required_args: 0
	pre_execute: fn (cmd cli.Command) ! {
		if cmd.args.len > cmd.required_args {
			eprintln('Unknown commands ${cmd.args}.\n')
			cmd.execute_help()
			exit(0)
		}
	}
	execute: build
	commands: [
		cli.Command{
			name: 'dev'
			description: 'Build the dev binary.'
			execute: build
		},
	]
	flags: [
		cli.Flag{
			flag: .bool
			name: 'appimage'
			description: 'Create an appimage from the built binary.'
			global: true
		},
	]
}
cmd.parse(os.args)

println('\rFinished.')
