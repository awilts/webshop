import NodeCache from 'node-cache';

const tokenCache = new NodeCache();

interface AuthToken {
	idToken: string;
	expiresIn: string;
}

export async function getAuthToken(): Promise<AuthToken> {
	if (tokenCache.get('token')) {
		return tokenCache.get('token');
	}
	const authUrl = process.env['AUTH_URL'];
	const authKey = process.env['AUTH_KEY'];
	const username = process.env['USER'];
	const password = process.env['PASSWORD'];
	const result = await fetch(`${authUrl}accounts:signInWithPassword?key=${authKey}`, {
		method: 'POST',
		headers: {
			'Content-Type': 'application/json'
		},
		body: JSON.stringify({
			returnSecureToken: true,
			email: username,
			password: password
		})
	});
	const authToken: AuthToken = await result.json();
	const expiresIn = parseInt(authToken.expiresIn);
	tokenCache.set('token', authToken, expiresIn);
	return authToken;
}
