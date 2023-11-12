import net
import vweb
import os

pub fn (mut app App) index() vweb.Result {
	return app.html(os.read_file('${paths.ui}/build/index.html') or { panic(err) })
}

fn get_idle_port(port int) int {
	mut l := net.listen_tcp(.ip6, ':${port}') or { return get_idle_port(port + 1) }
	l.close() or { panic(err) }
	return port
}

// The UI of this example builts into a static site.
// We use vweb to serve to UI on localhost.
fn (mut app App) serve() {
	app.port = get_idle_port(34763)
	spawn fn [mut app] () {
		app.mount_static_folder_at('${paths.ui}/build', '/')
		vweb.run(app, app.port)
	}()
}
