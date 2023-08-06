import shadowStyles from './picker-shadow-styles.css?inline';

function style(shadowRoot: ShadowRoot) {
	let style = document.createElement('style');
	style.innerHTML = shadowStyles;
	shadowRoot.appendChild(style);
}

function setKeymaps(shadowRoot: ShadowRoot) {
	const searchInput = shadowRoot.querySelector('.search input[type="search"]') as HTMLElement;
	document.addEventListener('keydown', (e) => {
		// e.preventDefault(); // for testing purposes in the browser
		if (((e.metaKey || e.ctrlKey) && e.key === 'f') || e.key === '/') {
			e.preventDefault();
			searchInput.focus();
		}
	});
	// Keyboard shortcut indicator
	const shortcutIndicator = document.createElement('div');
	shortcutIndicator.setAttribute('id', 'search-keys');
	shortcutIndicator.classList.add('hide');
	shortcutIndicator.innerHTML = '<div><kbd>/</kbd></div>';
	searchInput.parentElement?.appendChild(shortcutIndicator);
	searchInput.addEventListener('focus', () => {
		shortcutIndicator.classList.add('hide');
	});
	searchInput.addEventListener('blur', () => {
		shortcutIndicator.classList.remove('hide');
	});
}

function appendSettings(shadowRoot: ShadowRoot) {
	const settings = document.getElementById('custom-settings');
	if (!settings) return;
	const search = shadowRoot.querySelector('div.search')?.parentElement;
	search?.appendChild(settings);
}

export function highlightKeyboarSelect(button: HTMLElement) {
	button.classList.add('keyboard-active');
	setTimeout(() => {
		button.classList.remove('keyboard-active');
	}, 150);
}

export function customizePicker(shadowRoot: ShadowRoot) {
	setTimeout(() => {
		// Settings won't appear without this timeout. Using this hack until something better appears.
		setKeymaps(shadowRoot);
		appendSettings(shadowRoot);
		style(shadowRoot);
	}, 1);
}
