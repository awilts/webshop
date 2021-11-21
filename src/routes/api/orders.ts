/** @type {import('@sveltejs/kit').RequestHandler} */
import {getAuthToken} from "../../getAuthToken";

export async function post({params}): Promise<any> {

    await sleep(2000)

    const authToken = await getAuthToken()

    return {
        body: {
            msg: process.env['FOO'],
            authToken: authToken,
        }
    };
}

function sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
}
