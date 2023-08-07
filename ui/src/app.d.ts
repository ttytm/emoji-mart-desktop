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

// Webview functions
declare function play_sound(): void;
declare function toggle_audio(): Promise<bool>;
declare function open_in_browser(uri: string): void;
