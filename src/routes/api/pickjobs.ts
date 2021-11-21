import { getAuthToken } from '../../getAuthToken';
import { sleep } from '../../sleep';
import type { ServerRequest } from '@sveltejs/kit/types/hooks';

export interface PickjobResponse {
	total: number;
	pickjobs: {
		todo: string;
	}[];
}

async function getPickjobs(orderId: string) {
	const authToken = await getAuthToken();
	return await fetch(process.env['FFT_API_URL'] + 'pickjobs?orderRef=' + orderId, {
		method: 'GET',
		headers: {
			Authorization: 'Bearer ' + authToken.idToken,
			'Content-Type': 'application/json'
		}
	}).then((res) => res.json());
}

/** @type {import('@sveltejs/kit').RequestHandler} */
export async function get({ query }: ServerRequest): Promise<{ body: PickjobResponse }> {
	console.log('loading pickjobs');
	await sleep(1000);

	const orderId = query.get('orderId');
	const pickjobs = await getPickjobs(orderId);
	return {
		body: {
			...pickjobs
		}
	};
}
