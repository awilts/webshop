import { getAuthToken } from '../../getAuthToken';

interface Order {
	orderDate: string;
	consumer: {
		email: string;
		addresses: Address[];
	};
	orderLineItems: {
		article: {
			tenantArticleId: string;
			title: string;
		};
		quantity: number;
	}[];
}

export interface OrderResponse extends Order {
	id: string;
}

interface Address {
	street: string;
	houseNumber: string;
	postalCode: string;
	city: string;
	country: string;
}

function getDefaultAddress(): Address {
	return {
		street: 'Kalker Hauptstraße',
		houseNumber: '55',
		postalCode: '51103',
		city: 'Köln',
		country: 'DE'
	};
}

async function createOrder(order: Order): Promise<OrderResponse> {
	const authToken = await getAuthToken();
	return await fetch(process.env['FFT_API_URL'] + 'orders', {
		method: 'POST',
		headers: {
			Authorization: 'Bearer ' + authToken.idToken,
			'Content-Type': 'application/json'
		},
		body: JSON.stringify(order)
	}).then((res) => res.json());
}

export async function post(): Promise<{ body: OrderResponse }> {
	const order: Order = {
		orderDate: new Date().toISOString(),
		consumer: {
			addresses: [getDefaultAddress()],
			email: 'peter.pan@gmail.com'
		},
		orderLineItems: [
			{
				article: {
					tenantArticleId: '1',
					title: 'Kartoffelpüree'
				},
				quantity: 1
			}
		]
	};
	const createdOrder = await createOrder(order);

	return {
		body: {
			...createdOrder
		}
	};
}
