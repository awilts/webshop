/** @type {import('@sveltejs/kit').RequestHandler} */
export async function post({params}): Promise<any> {

    await sleep(2000)


    return {
        body: {
            msg: process.env['FOO']
        }
    };


}

function sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
}
