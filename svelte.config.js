import preprocess from 'svelte-preprocess';
import adapter from '@sveltejs/adapter-node';
import { optimizeImports } from "carbon-preprocess-svelte";

const config = {
	preprocess: [optimizeImports(), preprocess()],
	kit: {
		// hydrate the <div id="svelte"> element in src/app.html
		target: '#svelte',
		adapter: adapter({
			precompress: true,
			env: {
				host: 'HOST',
				port: 'PORT'
			}
		})
	}
};

export default config;
