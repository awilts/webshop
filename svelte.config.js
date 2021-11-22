import preprocess from 'svelte-preprocess';
import adapter from '@sveltejs/adapter-node';

const config = {
	preprocess: [preprocess()],
	kit: {
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
