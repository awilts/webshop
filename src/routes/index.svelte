<script lang="ts">
	import 'carbon-components-svelte/css/white.css';
	import { sleep } from '../sleep';
	import { Button,  TextInput } from 'carbon-components-svelte';
	import JsonLoader from '../components/JsonLoader.svelte';
	import type { OrderResponse } from './api/orders';

	let orderLoading = false;
	let order: OrderResponse;
	let pickjobLoading = false;
	let pickjob;
	let product = '';

	async function createOrder() {
		orderLoading = true;
		order = await fetch('/api/orders', {
			method: 'POST',
			body: JSON.stringify({
				product: product
			})
		}).then((res) => res.json());
		orderLoading = false;
		await getPickjob(order.id);
	}

	async function getPickjob(orderId) {
		pickjobLoading = true;
		const pickjobResponse = await fetch('/api/pickjobs?orderId=' + orderId).then((res) =>
			res.json()
		);
		if (pickjobResponse?.total > 0) {
			pickjobLoading = false;
			//TODO: type
			pickjob = pickjobResponse.pickjobs[0];
			return;
		}
		await sleep(500);
		await getPickjob(orderId);
	}
</script>

<div style="margin: 0 auto; max-width: 700px">
<!--	<Header company="Wilts" platformName="Webshop" />-->
	<TextInput
		style="margin: 45px 0 15px"
		bind:value={product}
		labelText="Product"
		placeholder="Enter some product..."
	/>
	<Button style="margin: 15px 0" disabled={!product} on:click={createOrder}>Create Order</Button>
	<JsonLoader objectName="Order" isLoading={orderLoading} value={order} />
	<JsonLoader objectName="Pickjob" isLoading={pickjobLoading} value={pickjob} />
</div>
