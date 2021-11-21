<div style="margin: 0 auto; max-width: 700px">
    <Header company="Wilts" platformName="Webshop"/>
    <TextInput style="margin: 45px 0 15px" bind:value={product} labelText="Product"
               placeholder="Enter some product..."/>
    <Button style="margin: 15px 0" disabled="{!product}" on:click={createOrder}>Create Order</Button>
    <JsonLoader objectName="Order" isLoading="{orderLoading}" value="{order}"/>
    <JsonLoader objectName="Pickjob" isLoading="{pickjobLoading}" value="{pickjob}"/>
</div>
<script>
    import "carbon-components-svelte/css/white.css";
    import {sleep} from "../sleep";
    import {Button, Header, TextInput} from "carbon-components-svelte";
    import JsonLoader from "../components/JsonLoader.svelte";

    let orderPromise
    let orderLoading = false
    let pickjobLoading = false
    let order
    let pickjob
    let product = '';

    async function createOrder() {
        orderLoading = true
        orderPromise = fetch('/api/orders', {
            method: "POST",
            body: {
                "product": product
            }
        }).then(res => res.json())
            .then(orderResponse => {
                orderLoading = false
                order = orderResponse
                getPickjob(orderResponse.id)
                return orderResponse
            })
    }

    async function getPickjob(orderId) {
        pickjobLoading = true
        const pickjobResponse = await fetch('/api/pickjobs?orderId=' + orderId)
            .then(res => res.json());
        if(pickjobResponse?.total>0){
            pickjobLoading = false
            //TODO: type
            pickjob = pickjobResponse.pickjobs[0]
            return
        }
        await sleep(500)
        await getPickjob(orderId)
    }
</script>