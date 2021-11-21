<div style="margin: 0 auto; max-width: 700px">
    <Header company="Wilts" platformName="Webshop"/>
    <TextInput style="margin: 45px 0 15px" bind:value={product} labelText="Product" placeholder="Enter some product..."/>
    <Button style="margin: 15px 0" disabled="{!product}" on:click={createOrder}>Create Order</Button>

    <OrderLoader orderPromise="{orderPromise}"/>
    <PickjobLoader orderId="{orderId}" pickjobsResponse="{pickjobsResponse}"/>
</div>
<script>
    import "carbon-components-svelte/css/white.css";
    import {sleep} from "../sleep";
    import {Button, Header, TextInput} from "carbon-components-svelte";
    import OrderLoader from "../components/OrderLoader.svelte";
    import PickjobLoader from "../components/PickjobLoader.svelte";

    let orderPromise
    let orderId = undefined;
    let product = '';
    let pickjobsResponse = undefined;

    async function createOrder() {
        orderPromise = fetch('/api/orders', {
            method: "POST",
            body: {
                "product": product
            }
        }).then(res => res.json())
            .then(order => {
                orderId = order.id
                loadPickjob(orderId)
                return order
            })
    }

    async function loadPickjob(orderId) {
        while (pickjobsLoading()) {
            await getPickjobs(orderId)
            await sleep(500)
        }
    }

    async function getPickjobs(orderId) {
        pickjobsResponse = await fetch('/api/pickjobs?orderId=' + orderId).then(res => res.json())
    }

    function pickjobsLoading() {
        if (!pickjobsResponse) return true
        return pickjobsResponse.total === 0;
    }
</script>