# Emoji Mart Desktop App

An emoji picker desktop application - it serves as an example of using [webview](https://github.com/ttytm/webview) with a modern web framework.
Nonetheless, it is a real and capable application, and nothing should stop you from simply using it.

## Contents

- [Application / Usage](#application--usage)
  - [Installation](#installation)
  - [Config](#config)
- [Webview Example / Building and Development](#webview-example--building-and-development)
  - [Preparation](#preparation)
  - [Building](#building)
  - [Building and Running in a Development Context](#building-and-running-in-a-development-context)
- [Credits](#credits)

## Application / Usage

<table align="center">
<tr>
  <th>Linux</th>
  <th>Windows</th>
  <th>macOS</th>
</tr>
<tr align="center">
  <td>
    <img width="400" src="https://github.com/ttytm/emoji-mart-desktop/assets/34311583/bce465bb-9d72-4c96-af94-e3a758657bc3">
  </td>
  <td>
    <img width="340" src="https://github.com/ttytm/emoji-mart-desktop/assets/34311583/2a7b86d5-9f85-4a8f-afc6-2bbb7f4a6ffe">
  </td>
  <td>
    <img width="450" src="https://github.com/ttytm/emoji-mart-desktop/assets/34311583/7c75c993-5445-4d1e-9090-a6d8de02c90e">
  </td>
</tr>
<tr align="center">
  <td>
    <img width="400" src="https://github.com/ttytm/emoji-mart-desktop/assets/34311583/b01099d8-6883-4c4b-9346-975bf675b0a4">
  </td>
  <td>
    <img width="340" src="https://github.com/ttytm/emoji-mart-desktop/assets/34311583/dbc3eba3-cd42-4d3a-831a-5ce431a519e4">
  </td>
  <td>
    <img width="450" src="https://github.com/ttytm/emoji-mart-desktop/assets/34311583/c92964e0-0200-4838-920f-bb9c905ea355">
  </td>
</table>

### Installation

- The projects [GitHub releases page](https://github.com/ttytm/emoji-mart-desktop/releases) provides prebuilt binaries for GNU/Linux, Windows and macOS.

### Config

Config values that are set via the in-app menu are saved for the next run.

```toml
# Lin: ~/.config/emoji-mart/
# Mac: ~/Library/Application Support/emoji-mart/
# Win: %USERPROFILE%/AppData/Roaming/emoji-mart/

# Default values
audio = true # enable audio hint on emoji-selection
frequent = true # display frequently used emojis
```

## Webview Example / Building and Development

### Preparation

- V - [Installing V from source](https://github.com/vlang/v#installing-v-from-source)

- npm - [npm/cli](https://github.com/npm/cli)

- emoji-mart-desktop

```sh
# Clone the repisitory
git clone https://github.com/ttytm/emoji-mart-desktop.git
cd emoji-mart-desktop
# Install dependencies
v install --once

# If you haven't used it before, prepare the webview library.
# Linux/macOS
~/.vmodules/webview/build.vsh
# Windows PowerShell
v $HOME/.vmodules/webview/build.vsh
```

### Building

If you just want to build the application for usage you can now run `./build.vsh`.

- The `dist/` directory will contain the build output.

### Building and Running in a Development Context

Since we use web technologies for the UI, a good part of the frontend-work can likely be done via the browser, just like working on a regular web application.
However, there comes a point where we want to connect our V program and the UI.

#### Example 1 - run a vite dev server and connect to it

When connecting to a vite dev server features like hot reloading are preserved.
Just like in the browser most changes on the UI will be immediately reflected in the application window.

- Run the app with the `dev` flag - this runs a vite dev server and connects to its localhost instance

  ```sh
  # Install the node modules beforehand if it's the first run.
  npm i --prefix ui/
  ```

  ```sh
  v -d dev run .
  ```

  ```sh
  # On Windows, it is recommended to use `gcc` for compilation.
  v -cc gcc -d dev run .
  ```

#### Example 2 - serve the prebuilt site

This is the regular build approach and how our final app is working.

- Build the UI - this uses SvelteKit as a static site generator

  ```sh
  # Install the node modules beforehand if it's the first run.
  npm i --prefix ui/
  ```

  ```sh
  npm run build --prefix ui/
  ```

- Run the app - this uses vweb to serve the previously build files locally and connect to it via webview

  ```sh
  v run .
  ```

  ```sh
  # Windows
  v -cc gcc run .
  ```

<br>

I hope this quick start guide and the examples in the repositories source code help on the way to release your own UI project.

## Related Projects

- [webview](https://github.com/ttytm/webview) - V module that allows to create a system level application, while using modern web technologies for the UI.
- [LVbag](https://github.com/ttytm/LVbag) - CLI tool to generate embedded file lists.

## Credits

- The app uses on the great work of [missive/emoji-mart](https://github.com/missive/emoji-mart)
- The icon used for the AppImage comes from [microsoft/fluentui-emoji](https://github.com/microsoft/fluentui-emoji)
