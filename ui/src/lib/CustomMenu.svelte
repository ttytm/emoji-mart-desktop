<script lang="ts">
	import Icon from '@iconify/svelte';
	import Popover from 'svelte-popover';
	import { config } from '$lib/stores';

	export let shadowRoot: any;
	let menuOpen = false;

	function handleEscape(e: KeyboardEvent) {
		if (e.key === 'Escape') {
			menuOpen = false;
			shadowRoot?.removeEventListener('keydown', handleEscape);
		}
	}

	function clickOutside(node: HTMLElement, handler: () => void): { destroy: () => void } {
		const onClick = (event: MouseEvent) => {
			return (
				node &&
				(event.target as HTMLElement).id != 'custom-settings__menu-btn__svg' &&
				!node.contains(event.target as HTMLElement) &&
				!event.defaultPrevented &&
				handler()
			);
		};
		shadowRoot.addEventListener('click', onClick, true);
		return {
			destroy() {
				shadowRoot.removeEventListener('click', onClick, true);
			}
		};
	}

	async function toggleAudio() {
		$config.audio = await window.toggle_audio();
		if ($config.audio) window.play_audio();
	}

	$: if (menuOpen) document.addEventListener('keydown', handleEscape);
</script>

<div id="custom-settings">
	<Popover arrow={false} bind:open={menuOpen}>
		<button id="custom-settings__menu-btn" class={menuOpen ? 'open' : 'close'} slot="target">
			<Icon icon="heroicons-solid:menu" width="20" id="custom-settings__menu-btn__svg" />
		</button>
		<div
			dir="ltr"
			aria-label="Settings"
			class="menu {menuOpen ? 'open' : 'close'}"
			slot="content"
			use:clickOutside={() => (menuOpen = false)}
		>
			<div>
				<button on:click={toggleAudio} aria-hidden="true" tabindex="-1" class="option">
					{#if $config.audio}
						<Icon icon="fa-solid:volume-up" />
					{:else}
						<Icon icon="fa-solid:volume-mute" />
					{/if}
					<span class="margin-small-lr">Audio</span>
				</button>
			</div>
			<div>
				<button
					on:click={() => window.open_in_browser('https://github.com/ttytm/emoji-mart-desktop')}
					class="option"
				>
					<Icon icon="simple-icons:github" />
					<span class="margin-small-lr"> GitHub</span>
				</button>
			</div>
		</div>
	</Popover>
</div>

<style>
	/* Only display in emoji-pickers shadow root. Fixes a potential display on first launch / reload without style */
	#custom-settings {
		display: none;
	}
</style>
