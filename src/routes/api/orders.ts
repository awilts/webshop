import {getAuthToken} from '../../getAuthToken';
import type {ServerRequest} from "@sveltejs/kit/types/hooks";

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
    console.log(1);
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

function parseProductTitle(body: string) {
    const parsedBody = JSON.parse(body);
    if ("product" in parsedBody) {
        return parsedBody["product"]
    } else {
        throw new Error(`Received invalid input: ${body}. Expected JSON with property "product"`)
    }
}

export async function post({body}: ServerRequest): Promise<{ body: OrderResponse }> {
    const title = parseProductTitle(body as string);
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
                    title: title
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
