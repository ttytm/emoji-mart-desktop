import net
import rand
import vweb
import os

struct Context {
	vweb.Context
}

pub fn (mut ctx Context) index() vweb.Result {
	return ctx.html(os.read_file('${ui_path}/index.html') or { panic(err) })
}

fn get_idle_port() int {
	port := rand.int_in_range(1024, 9999) or { panic(err) }
	mut l := net.listen_tcp(.ip6, ':${port}') or { return get_idle_port() }
	l.close() or { panic(err) }
	return port
}

// The UI of this example builts into a static site. We serve it using vweb.
// However, we could rely on a npm dependency and use an os.Process to run
// e.g., `npm run preview` or use `serve` and connect to its localhost address.
// Check out the `use-serve` branch to see an example.
fn (mut app App) serve() {
	app.port = get_idle_port()
	// Serve UI with vweb on localhost.
	spawn fn (port int) {
		mut web_ctx := Context{}
		web_ctx.mount_static_folder_at(ui_path, '/')
		vweb.run(web_ctx, port)
	}(app.port)
}
