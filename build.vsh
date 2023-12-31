#!/usr/bin/env -S v

import cli
import os

const app_root = @VMODROOT

fn exec(cmd string, work_folder string, args []string) ! {
	mut p := new_process(find_abs_path_of_executable(cmd) or {
		return error('failed to find `${cmd}`.\nMake sure ${cmd} is executable.')
	})
	p.set_work_folder(work_folder)
	p.set_args(args)
	p.wait()
}

fn build_ui() ! {
	// Install node modules
	exec('npm', '${'${app_root}/ui'}', ['install'])!
	// Build static web app
	exec('npm', '${app_root}/ui', ['run', 'build'])!
	// Remove `dist/` if it exits - ignore errors if it doesn't
	rmdir_all('dist') or {}
	// Create `dist/` - fail is next to impossible as `dist/` does not exist at this point
	mkdir_all('dist/ui')!
	// Copy UI files to dist
	cp_all('ui/build/', 'dist/ui/', false)!
}

fn gen_embeds() ! {
	println('Embedding files')
	chdir(app_root)!
	// Use LVbag to generate the embed file lists.
	lvb := find_abs_path_of_executable('lvb') or { './lvb' }
	execute_opt('${lvb} -bag ui -o src/lvb.v -f dist/ui')!
	// Append a version const.
	mut f := open_append('src/lvb.v')!
	// `git describe --tags` -> v0.3.0@g3804a82. Use in App when constants evaluate at comptime.
	version := "const version = '${execute_opt('git describe --tags')!.output.trim_space()}'"
	f.write_string(version)!
	f.close()
	// Format.
	execute_opt('v fmt -w src/lvb.v')!
}

fn build_bin(flags string) ! {
	cc := $if macos { 'clang' } $else { 'gcc' }
	out_file := 'emoji-mart' + $if windows { '.exe' } $else { '' }
	cmd := 'v -cc ${cc} ${flags} -o ${app_root}/dist/${out_file} ${app_root}/src'
	println('Building binary: ${cmd}')
	execute_opt($if windows { 'powershell -command ${cmd}' } $else { cmd })!
}

fn build(cmd cli.Command) ! {
	if !cmd.flags.get_bool('skip-ui')! {
		build_ui()!
	}
	if !cmd.flags.get_bool('skip-bin')! {
		gen_embeds()!
		mut flags := '-d embed' + if cmd.name == 'dev' { '' } else { ' -prod' }
		build_bin(flags)!
	}
	if cmd.flags.get_bool('appimage')! {
		build_appimage() or { return error('failed to build appimage. "${err}"') }
	}
}

fn build_appimage() ! {
	println('Building appimage')
	mkdir_all('dist/appimage/AppDir/usr/bin')!
	mkdir_all('dist/appimage/AppDir/usr/share/icons')!
	cp('dist/emoji-mart', 'dist/appimage/AppDir/usr/bin/emoji-mart')!
	cp('assets/AppImageBuilder.yml', 'dist/appimage/AppImageBuilder.yml')!
	cp('assets/emoji-mart.png', 'dist/appimage/AppDir/usr/share/icons/emoji-mart.png')!
	exec('appimage-builder', '${app_root}/dist/appimage', ['--recipe', 'AppImageBuilder.yml',
		'--skip-tests'])!
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
		cli.Flag{
			flag: .bool
			name: 'skip-bin'
			description: 'Skip building the binary.'
		},
		cli.Flag{
			flag: .bool
			name: 'skip-ui'
			description: 'Skip building the UI.'
		},
	]
}
cmd.parse(os.args)

println('\rFinished.')
