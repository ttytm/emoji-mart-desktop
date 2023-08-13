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
	import pop from '$lib/assets/pop.wav';

	let pickerElem: any, shadowRoot: any; // 🥲
	let selectSound: HTMLAudioElement;

	function handleSelect(emojiData: any, e: Event) {
		if (e instanceof KeyboardEvent) {
			highlightKeyboarSelect(
				shadowRoot.querySelector('button[aria-selected="true"][data-keyboard="true"]')
			);
		}
		navigator.clipboard.writeText(emojiData.native);
		if ($config.audio) selectSound.play();
	}

	onMount(async () => {
		pickerElem.appendChild(
			new Picker({
				data,
				autoFocus: true,
				dynamicWidth: true,
				onEmojiSelect: handleSelect
			})
		);
		shadowRoot = document.querySelector('em-emoji-picker')?.shadowRoot;
		if (!shadowRoot) {
			console.error('Failing finding emoji-mart element.');
			return;
		}
		customizePicker(shadowRoot);
		selectSound = new Audio(pop);
		$config = await get_config();
	});
</script>

<div bind:this={pickerElem} />
<CustomMenu {shadowRoot} {selectSound} />
