<style>
    .headline {
        background-color: #1386d2;
    }
</style>

<h1 class="headline">Welcome to the Webshop</h1>

<span>Product:</span><input bind:value={product}>

<button on:click={createOrder}>Submit stuff</button>

<div>
    {#await orderPromise}
        <p>Loading Order...</p>
        <Jumper size="60" color="#FF3E00" unit="px" duration="1s"/>
    {:then order}
        Order:
        {#if order}
            {JSON.stringify(order)}
        {/if}
    {/await}
</div>

<br>

<span>OrderID: {orderId}</span>

<br>
{#if orderId}
    {#if pickjobs?.total > 0}
        Pickjobs: {JSON.stringify(pickjobs)}
    {:else}
        <p>Loading Pickjob...</p>
        <Jumper size="60" color="#FF3E00" unit="px" duration="1s"/>
    {/if}
{/if}

<script>
    import {Jumper} from 'svelte-loading-spinners'
    import {sleep} from "../sleep";

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