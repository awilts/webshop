<div style="margin: 0 auto; max-width: 700px">
    <Header company="Wilts" platformName="Webshop"/>
    <TextInput style="margin: 45px 0 15px" bind:value={product} labelText="Product" placeholder="Enter some product..."/>
    <Button style="margin: 15px 0" on:click={createOrder}>Create Order</Button>

    <Tile style="margin: 15px 0">
        {#await orderPromise}
            <p>Loading Order...</p>
            <Loading withOverlay={false} small/>
        {:then order}
            {#if order}
                {JSON.stringify(order)}
            {/if}
        {/await}
    </Tile>

    <Tile style="margin: 15px 0">
        {#if orderId}
            {#if pickjobs?.total > 0}
                Pickjobs: {JSON.stringify(pickjobs)}
            {:else}
                <p>Loading Pickjob...</p>
                <Loading withOverlay={false} small/>
            {/if}
        {/if}
    </Tile>
</div>
<script>
    import "carbon-components-svelte/css/white.css";
    import {sleep} from "../sleep";
    import {Button, Header, Loading, TextInput, Tile} from "carbon-components-svelte";

    let orderPromise
    let orderId = undefined;
    let product = '';
    let pickjobs = undefined;

    async function createOrder() {
        orderPromise = fetch('/api/orders', {
            method: "POST",
            body: {
                "product": product
            }
        }).then(res => res.json())
            .then(order => {
                orderId = order.createdOrder
                loadPickjob(orderId)
                console.log("go");
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
        pickjobs = await fetch('/api/pickjobs?orderId=' + orderId).then(res => res.json())
    }

    function pickjobsLoading() {
        if (!pickjobs) return true
        return pickjobs.total === 0;
    }
</script>