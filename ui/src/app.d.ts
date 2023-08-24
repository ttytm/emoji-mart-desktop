// See https://kit.svelte.dev/docs/types#app
// for information about these interfaces
declare global {
	namespace App {
		// interface Error {}
		// interface Locals {}
		// interface PageData {}
		// interface Platform {}
	}
}

declare module 'svelte-popover';

type Config = {
	audio: boolean;
};

// Webview functions
declare function get_config(): Promise<Config>;
declare function play_audio(): Promise<void>;
declare function toggle_audio(): Promise<bool>;
declare function open_in_browser(uri: string): Promise<void>;
