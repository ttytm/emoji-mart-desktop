# Emoji Mart Desktop App

An emoji picker desktop application - built to serve as an example of using [webview](https://github.com/ttytm/webview) with a modern web framework.
Nevertheless, it is a real and capable application. So if you just want to use it, nothing should stop you from doing so.

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

It is developed with focus on systems running GNU Linux, but can also be used other platforms.

<div align="center">
  <img width="412" src="https://github.com/ttytm/emoji-mart-desktop/assets/34311583/bce465bb-9d72-4c96-af94-e3a758657bc3">
  <img width="412" src="https://github.com/ttytm/emoji-mart-desktop/assets/34311583/b01099d8-6883-4c4b-9346-975bf675b0a4">
</div>

### Installation

- Linux: Download an Appimage from the [releases](https://github.com/ttytm/emoji-mart-desktop/releases) page.
- macOS/Windows: There is no bundling atm. So it is required to self compile it and keep the binary and ui files side by side. See [Building](#preparation).

### Config

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

**Prerequisites**

- V - [Installing V from source](https://github.com/vlang/v#installing-v-from-source)

- npm - [npm/cli](https://github.com/npm/cli)

Either pull and install the required V modules step by step, or use V's package manager to install the project into your `.vmodules` dir and take care of the other modules.

- Step by Step
  Clone the repository
  ```sh
  git clone https://github.com/ttytm/emoji-mart-desktop.git
  ```
  Install webview
  ```sh
  v install --git https://github.com/ttytm/webview
  # Linux/macOS
  ~/.vmodules/webview/build.vsh
  # Windows
  v run $HOME/.vmodules/webview/build.vsh
  ```
  Install `miniaudio` - a V module that this app is using
  ```sh
  v install --git https://github.com/Larpon/miniaudio
  ```
- Or use `vmp` to combine the steps above. The project will be installed into your `.vmodules` dir
  ```sh
  v install --git https://github.com/ttytm/emoji-mart-desktop
  # Don't forget to prepare the webview library if you haven't used it already.
  # Linux/macOS
  ~/.vmodules/webview/build.vsh
  # Windows
  v run $HOME/.vmodules/webview/build.vsh
  ```

### Building

If you just want to build the application for usage you can now run `./build.vsh`.

- The `dist/` directory will contain the build output.
- On macOS and Windows it's currently required that the contents of `dist/` (`emoji-mart` / `emoji-mart.exe` and `ui/`) are kept next to each other.
- On Linux you can run `./build.vsh --appimage` to build the AppImage.

### Building and Running in a Development Context

Since we use web technologies for the UI, a good part of the frontend-work can likely be done via the browser, just like working on a regular web application.
However, there comes a point where we want to connect our V program and the UI.

> **Note**
> When running and building on Windows, it is recommended to use `gcc` for compilation. E.g.:
>
> ```sh
> v -cc gcc run .
> ```

#### Example 1 - run a vite dev server and connect to it

When connecting to a vite dev server features like hot reloading are preserved.
Just like in the browser most changes on the UI will be immediately reflected in the application window.

- Run the app with the `dev` flag - this runs a vite dev server and connects to its localhost instance

  ```sh
  # install the node modules if it's the first run
  # npm i --prefix ui/

  v -d dev run .
  ```

  Visual example (Might be outdated):

  https://github.com/ttytm/emoji-mart-desktop/assets/34311583/86ad765c-ab6a-4970-b2ac-a8a00c399989

#### Example 2 - serve the prebuilt site

This is the regular build approach and what our final app is doing.

- Build the UI - this uses SvelteKit as a static site generator

  ```sh
  # install the node modules if it's the first run
  # npm i --prefix ui/

  npm run build --prefix ui/
  ```

- Run the app - this uses vweb to serve the previously build files locally and connect to it via webview

  ```sh
  v run .
  ```

<br>

I hope this quick start guide and the examples in the repositories source code help on the way to release your own UI project.

## Credits

- The app uses on the great work of [missive/emoji-mart](https://github.com/missive/emoji-mart)
- The icon used for the AppImage comes from [microsoft/fluentui-emoji](https://github.com/microsoft/fluentui-emoji)
