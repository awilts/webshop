<style>
    .headline{
        background-color: #1386d2;
    }
</style>

<h1 class="headline">Welcome to the Webshop</h1>

<button on:click={createOrder}>Submit stuff</button>

<div>
    {#await responsePromise}
        <Jumper size="60" color="#FF3E00" unit="px" duration="1s"/>
    {:then response}
        {#if response}
            Response: {JSON.stringify(response)}
        {/if}
    {:catch error}
        <p style="color: red">{error.message}</p>
    {/await}
</div>

<script>
    import { Jumper } from 'svelte-loading-spinners'
    let responsePromise

    async function createOrder() {
        responsePromise = fetch('/api/orders', {
            method: "POST",
            body: {
                "test": "bar"
            }
        }).then(res => res.json())
    }

</script>