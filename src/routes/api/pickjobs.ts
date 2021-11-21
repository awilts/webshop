import {getAuthToken} from "../../getAuthToken";
import {sleep} from "../../sleep";

async function getPickupJobs(orderId: string) {
    const authToken = await getAuthToken()
    return await fetch(process.env['FFT_API_URL'] + "pickjobs?orderRef="+orderId, {
        method: "GET",
        headers: {
            'Authorization': 'Bearer ' + authToken.idToken,
            'Content-Type': 'application/json'
        }
    }).then(res => res.json());
}

/** @type {import('@sveltejs/kit').RequestHandler} */
export async function get({query}): Promise<any> {
    console.log("loading pickjobs");
    await sleep(1000)

    const orderId = query.get("orderId");
    const pickjobs = await getPickupJobs(orderId);
    return {
        body: {
            ...pickjobs
        }
    };
}
