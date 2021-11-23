import type {ServerRequest} from '@sveltejs/kit/types/hooks';
import {getAuthToken} from "../../../getAuthToken";

export async function post(serverRequest: ServerRequest): Promise<{ body: any }> {

    const authToken = await getAuthToken()

    interface SubscriptionCreation {
        name: string
        event: string
        callbackUrl: string
        headers: {
            key: string
            value: string
        }
    }

    const subscriptionCreation: SubscriptionCreation ={
        name: "wilts-webshop",
        event: "PICK_JOB_CREATED",
        callbackUrl: "https://cloudrun-webshop-4dwt5urnqq-ey.a.run.app/api/pickjobs",
        headers: {
            key: "foo-token",
            value: "bar-value"
        }
    }

    const subCreationResult = await fetch(process.env['FFT_API_URL'] + 'subscriptions', {
        method: 'POST',
        headers: {
            Authorization: 'Bearer ' + authToken.idToken,
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(subscriptionCreation)
    }).then((res) => res.json());


    console.log(subCreationResult);


    return {
        body: {
            ...subCreationResult
        }
    };
}

