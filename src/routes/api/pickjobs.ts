import { getAuthToken } from '../../getAuthToken';
import type { ServerRequest } from '@sveltejs/kit/types/hooks';

export interface PickjobResponse {
	total: number;
	pickjobs: {
		created: string
		facilityRef: string
		id: string
		lastModified: string
		orderRef: string
		status: string
		version: number
	}[];
}

async function getPickjobs(orderId: string) {
	console.log(2);
	const authToken = await getAuthToken();
	return await fetch(process.env['FFT_API_URL'] + 'pickjobs?orderRef=' + orderId, {
		method: 'GET',
		headers: {
			Authorization: 'Bearer ' + authToken.idToken,
			'Content-Type': 'application/json'
		}
	}).then((res) => res.json());
}

export async function get({ query }: ServerRequest): Promise<{ body: PickjobResponse }> {
	const orderId = query.get('orderId');
	const pickjobs = await getPickjobs(orderId);
	return {
		body: {
			...pickjobs
		}
	};
}
