# Emoji Mart Desktop App

An emoji picker desktop application - built to serve as an example of using [webview](https://github.com/ttytm/webview) with a modern web framework.
Nevertheless, it is a real and capable application. So if you just want to use it, nothing should stop you from doing so.

## Application - Usage

It is developed with focus on systems running GNU Linux but can also be used on macOS.

<div align="center">
  <img width="412" src="https://github.com/ttytm/emoji-mart-desktop/assets/34311583/bce465bb-9d72-4c96-af94-e3a758657bc3">
  <img width="412" src="https://github.com/ttytm/emoji-mart-desktop/assets/34311583/b01099d8-6883-4c4b-9346-975bf675b0a4">
</div>

### Usage

- Linux: Download an Appimage from the [releases](https://github.com/ttytm/emoji-mart-desktop/releases) page.
- macOS: There is no bundling atm. So it is required to self compile it and keep the binary and ui files side by side.</sub>

## Webview Example - Building and Development

The following steps show how to build and run the application.

### Prerequisites

- npm: [npm/cli](https://github.com/npm/cli)

- V Webview Binding; [ttytm/webview](https://github.com/ttytm/webview)

- Miniaudio as a V module dependency that this app is using

  ```
  v install --git https://github.com/Larpon/miniaudio
  ```

### Building

If you just want to build the application for usage you can now run `./build.vsh`. \
The `dist/` directory will contain the build output. Run `./build.vsh --appimage` to build the AppImage on Linux.

### Building and Running the App in a Development Context

Since we use web technologies for the UI, a good part of the work on it can likely be done via the browser, just like working on a regular web application.
However, there comes a point where we want to connect our V program and the UI. Below you will find two examples.

#### Example 1 - run a vite dev server and connect to it

When connecting to a vite dev server features like hot reloading are preserved.
Just like in the browser most changes on the UI will be immediately reflected in the application window.

- Run the dev server in one terminal instance

  ```sh
  cd ui
  # npm install # install node_modules if it's the first run
  npm run dev
  ```

- Run the app in a another terminal - connecting to the UI on the running vite dev server.

  ```sh
  v -d dev run .
  ```

  Visual example:

  https://github.com/ttytm/emoji-mart-desktop/assets/34311583/86ad765c-ab6a-4970-b2ac-a8a00c399989

#### Example 2 - serve the prebuilt site

This is the regular build approach and what our final app is doing.

- Build the UI - the App uses SvelteKit as a static site generator.

  ```sh
  # npm i --prefix ui/
  npm run build --prefix ui/
  ```

- Run the app - using vweb(or e.g. serve) to serve the previously build files locally and connect to it via webview.

  ```sh
  v run .
  ```

<br>

I hope this quick start guide and the examples in the repositories source code help on the way to release your own UI project.

## Credits

- The app uses on the great work of [missive/emoji-mart](https://github.com/missive/emoji-mart).
- The icon used for the AppImage comes from [microsoft/fluentui-emoji](https://github.com/microsoft/fluentui-emoji)
