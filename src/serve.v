import net
import vweb
import os

struct Context {
	vweb.Context
}

pub fn (mut ctx Context) index() vweb.Result {
	return ctx.html(os.read_file('${ui_path}/build/index.html') or { panic(err) })
}

fn get_idle_port(port int) int {
	mut l := net.listen_tcp(.ip6, ':${port}') or { return get_idle_port(port + 1) }
	l.close() or { panic(err) }
	return port
}

// The UI of this example builts into a static site.
// We use vweb to serve to UI on localhost.
fn (mut app App) serve() {
	app.port = get_idle_port(app.config.port)
	spawn fn (port int) {
		mut web_ctx := Context{}
		web_ctx.mount_static_folder_at('${ui_path}/build', '/')
		vweb.run(web_ctx, port)
	}(app.port)
}
