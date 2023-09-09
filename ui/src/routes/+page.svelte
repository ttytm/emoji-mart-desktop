<script lang="ts">
	// Modules
	import { Picker } from 'emoji-mart';
	import data from '@emoji-mart/data';
	// Builtin
	import { onMount } from 'svelte';
	// Internal
	import CustomMenu from '$lib/CustomMenu.svelte';
	import { customizePicker, highlightKeyboarSelect } from '$lib/picker-customization';
	import { config } from '$lib/stores';

	let pickerElem: any, shadowRoot: any; // 🥲

	function handleSelect(emojiData: any, e: Event) {
		if (e instanceof KeyboardEvent) {
			highlightKeyboarSelect(
				shadowRoot.querySelector('button[aria-selected="true"][data-keyboard="true"]')
			);
		}
		navigator.clipboard.writeText(emojiData.native);
		window.handle_select(localStorage.getItem('emoji-mart.frequently')!);
	}

	onMount(async () => {
		localStorage.setItem('emoji-mart.frequently', await window.get_cache());
		$config = await get_config();
		pickerElem.appendChild(
			new Picker({
				data,
				autoFocus: true,
				dynamicWidth: true,
				onEmojiSelect: handleSelect,
				maxFrequentRows: !$config.frequent ? 0 : 4
			})
		);
		shadowRoot = document.querySelector('em-emoji-picker')?.shadowRoot;
		if (!shadowRoot) {
			console.error('Failing finding emoji-mart element.');
			return;
		}
		customizePicker(shadowRoot);
	});
</script>

<div bind:this={pickerElem} />
<CustomMenu {shadowRoot} />
