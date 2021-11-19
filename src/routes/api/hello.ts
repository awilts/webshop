
/** @type {import('@sveltejs/kit').RequestHandler} */
export async function get({ params }): Promise<any> {
    // the `slug` parameter is available because this file
    // is called [slug].json.js
    const { slug } = params;

    return {
        body: {
            msg: "gello!"
        }
    };
}